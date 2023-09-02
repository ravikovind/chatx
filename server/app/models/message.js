/// create a message schema for mongodb
import mongoose from 'mongoose';

const messageSchema = new mongoose.Schema({
    message: {
        type: String,
        trim: true,
        default: "New message",
        required: false,
    },
    type: {
        type: String,
        enum: ["message", "image", "video", "audio", "document", "location", "contact", "sticker", "gif"],
        default: "message",
        trim: true,
        required: false,
    },
    status: {
        type: String,
        enum: ["sent", "delivered", "read"],
        default: "sent",
        trim: true,
        required: false,
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        trim: true,
    },
    receivers: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        trim: true,
    }],
    deleted: {
        type: Boolean,
        default: false,
        required: false,
    },
}, {
    timestamps: true,
    versionKey: false,
},);


/// create a message model
const Message = mongoose.model('Message', messageSchema);

/// export the message model
export default Message;