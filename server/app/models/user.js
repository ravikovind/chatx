/// create a user schema for mongodb
import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      match: [/^[a-zA-Z ]+$/, "Name should be valid."],
      trim: true,
      required: false,
    },
    email: {
      type: String,
      match: [/^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$/, "Email should be valid."],
      trim: true,
      required: true,
      lowercase: true,
    },
    password: {
      type: String,
      trim: true,
      required: true,
    },
    verified: {
      type: Boolean,
      default: false,
    },
    phone: {
      type: String,
      match: [/^[0-9]+$/, "Phone number should be valid."],
      trim: true,
      required: false,
    },
    gender: {
      type: String,
      enum: ["male", "female", "other"],
      trim: true,
      required: false,
    },
    dateOfBirth: {
      type: Date,
      required: false,
    },
    avatar: {
      type: String,
      required: false,
    },
    status: {
      type: Boolean,
      default: true,
    },
    devices: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Device",
        required: false,
        trim: true,
      },
    ],
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

/// index the user schema for faster query name and phone
userSchema.index({ name: 1, phone: 1 });

/// create a user model
const User = mongoose.model("User", userSchema);

/// export the user model
export default User;
