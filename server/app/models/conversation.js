import mongoose from "mongoose";

const conversationSchema = new mongoose.Schema(
    {
        participants: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "User",
                required: true,
            },
        ],
        messages: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Message",
                required: false,
            },
        ],
        type: {
            type: String,
            enum: ["private", "group"],
            default: "private",
            trim: true,
            required: false,
        },
        name: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        description: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        avatar: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        status: {
            type: Boolean,
            default: true,
            required: false,
        },
        createdBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: false,
        },
    },
    {
        timestamps: true,
        versionKey: false,
    },
);

/// index the conversation schema for faster query name
conversationSchema.index({ name: 1 });

/// create a conversation model
const Conversation = mongoose.model("Conversation", conversationSchema);

/// export the conversation model
export default Conversation;