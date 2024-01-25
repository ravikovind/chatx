import { config } from "dotenv";
config();

import express from "express";
import http from "http";
import bodyParser from "body-parser";
import mongoose from "mongoose";
import cors from "cors";
import { Server } from "socket.io";

/// create a server with express
const app = express();

/// create a server with http
const server = http.createServer(app);
const options = { cors: true, origins: "*" };

/// create a socket with socket.io
const io = new Server(server, options);

/// connect to mongodb
const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", () => console.log("open connection to database"));
mongoose
  .connect(process.env.DB_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("connected to database successfully"))
  .catch((err) => console.log(`error connecting to database: ${err}`));

/// use body parser
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

/// use cors
app.use(cors());

/// use socket.io
io.on("connection", (socket) => {
  console.log(`a user connected: ${socket.id}`);
  socket.on("disconnect", () => console.log(`user disconnected: ${socket.id}`));

  /// conversation event
  socket.on("conversation", (map) => {
    /// map contains conversation as object and room as string
    console.log(`conversation event: ${JSON.stringify(map)}`);
    let conversation = map.conversation; /// it's going to be a room
    if (!conversation)
      return console.log("conversation or room is not defined");
    /// check if room is already created and socket.id is already joined
    if (io.sockets.adapter.rooms.has(conversation)) {
      if (io.sockets.adapter.rooms.get(conversation).has(socket.id)) {
        io.to(conversation).emit("conversation", map);
        return console.log(
          `room ${conversation} already created or socket ${socket.id} already joined, so just emit the conversation event.`
        );
      } else {
        socket.join(conversation);
        return console.log(
          `room ${conversation} just created and socket ${socket.id} joined.`
        );
      }
    } else {
      socket.join(conversation);
      return console.log(
        `socket ${socket.id} joined room ${conversation} for the first time.`
      );
    }
  });
});

/// throw error if no route found
app.get("/", (req, res) => {
  /*
    show this code to show lottie animation 
    <script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<lottie-player src="https://assets9.lottiefiles.com/packages/lf20_zyu0ctqb.json"  background="transparent"  speed="1"  style="width: 300px; height: 300px;"  loop  autoplay></lottie-player>
    */
  res.send(`
<html>
<head>
<title>Error 404</title>
</head>
<body>
<div>
<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<lottie-player src="https://assets9.lottiefiles.com/packages/lf20_zyu0ctqb.json"  background="transparent"  speed="1" loop  autoplay></lottie-player>
</div>
</body>
</html>
`);
});

/// health check of the server
app.get("/health", (req, res) => {
  res.status(200).json({ message: "server is ready to serve" });
});

/// import routes
import AuthRouter from "./app/routes/auth.js";
import UserRouter from "./app/routes/user.js";

/// use routes
app.use("/api/v1/auth", AuthRouter);
app.use("/api/v1/user", UserRouter);

/// start the server
server
  .listen(process.env.PORT, () =>
    console.log(`server is running on port ${process.env.PORT}`)
  )
  .on("error", (err) => console.log(`error in starting server: ${err}`));
