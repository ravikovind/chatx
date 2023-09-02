import Conversation from "../models/conversation.js";

export const createConversation = async (req, res) => {
    let createdBy = req.user;
    const { name, description, type, participants } = req.body;
    console.log(req.body);
    try {
        const conversationOf = await Conversation.findOne({
            participants: { $all: [...participants] },
            type: type,
        });
        if (conversationOf) {
            return res.status(200).json(conversationOf);
        }

        let obj = {};
        if (name) obj.name = name;
        if (description) obj.description = description;
        if (type) obj.type = type === "group" ? "group" : "private";
        if (participants) obj.participants = participants;
        if (createdBy) obj.createdBy = createdBy;

        const conversation = await Conversation.create(obj);
        if (conversation) {
            return res.status(200).json(conversation);
        }
        throw new Error('there was an error creating the conversation.');
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

export const conversations = async (req, res) => {

    const id = req.user;

    try {
        let conversations = await Conversation.find({ participants: { $in: [id] } }).populate("participants");
        /// ignore the messages, createdBy
        conversations = conversations.map((conversation) => {
            return {
                _id: conversation._id,
                name: conversation.name,
                description: conversation.description,
                type: conversation.type,
                participants: conversation.participants,
                status: conversation.status,
                createdAt: conversation.createdAt,
                updatedAt: conversation.updatedAt,
            };
        });

        if (conversations) {
            return res.status(200).json(conversations);
        }
        throw new Error('there was an error fetching the conversations.');
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

// export const conversation = async (req, res) => {
//     const { id } = req.params;
//     try {
//         const conversation = await Conversation.findById(id).populate("participants messages");
//         if (conversation) {
//             return res.status(200).json(conversation);
//         }
//         throw new Error('conversation not found.');
//     } catch (error) {
//         return res.status(500).json({ message: error.message });
//     }
// }



// export const createMessage = async (req, res) => {
//     let sender = req.user._id;
//     const { conversation } = req.params;
//     const { receiver, message, type } = req.body;
//     /// check if the conversation is valid
//     try {
//         let conversationOf = await Conversation.findById(conversation);
//         if (!conversationOf) {
//             throw new Error('conversation not found.');
//         }
//         /// check if the sender is a participant of the conversation
//         if (!conversationOf.participants.includes(sender)) {
//             throw new Error('You are not a participant of this conversation.');
//         }
//         /// check if the receiver is a participant of the conversation
//         if (!conversationOf.participants.includes(receiver)) {
//             throw new Error('Receiver is not a participant of this conversation.');
//         }
//         /// create the message
//         const messageOf = new Message.create({
//             message: message,
//             type: type,
//             sender: sender,
//             receiver: receiver,
//         });
//         if (message) {
//             conversationOf.messages.push(messageOf._id);
//             await conversationOf.save();
//             return res.status(200).json(messageOf);
//         }
//         throw new Error('there was an error creating the message.');
//     } catch (error) {
//         return res.status(500).json({ message: error.message });
//     }
// }

// export const messages = async (req, res) => {
//     const { id } = req.params;
//     try {
//         const conversation = await Conversation.findById(id).populate("participants messages");
//         if (conversation) {
//             return res.status(200).json(conversation.messages);
//         }
//         throw new Error('conversation not found.');
//     } catch (error) {
//         return res.status(500).json({ message: error.message });
//     }
// }

// export const messageUpdate = async (req, res) => {
//     let sender = req.user._id;
//     const { conversation, message, status } = req.body;

//     try {
//         let conversationOf = await Conversation.findById(conversation);
//         if (!conversationOf) {
//             throw new Error('conversation not found.');
//         }
//         /// check if the sender is a participant of the conversation
//         if (!conversationOf.participants.includes(sender)) {
//             throw new Error('you are not a participant of this conversation.');
//         }
//         /// check if the message is a part of the conversation
//         if (!conversationOf.messages.includes(message)) {
//             throw new Error('message is not a part of this conversation.');
//         }
//         /// update the message status
//         let updated = conversationOf.messages.map((msg) => {
//             if (msg._id === message) {
//                 msg.status = status;
//             }
//             return msg;
//         }
//         );
//         conversationOf.messages = updated;
//         await conversationOf.save();
//         return res.status(200).json(conversationOf.messages);
//     } catch (error) {
//         return res.status(500).json({ message: error.message });
//     }

// }

// export const messageDelete = async (req, res) => {
//     let sender = req.user._id;
//     const { message, conversation } = req.body;
//     try {
//         let conversationOf = await Conversation.findById(conversation);
//         if (!conversationOf) {
//             throw new Error('conversation not found.');
//         }
//         /// check if the sender is a participant of the conversation
//         if (!conversationOf.participants.includes(sender)) {
//             throw new Error('you are not a participant of this conversation.');
//         }
//         /// check if the message is a part of the conversation
//         if (!conversationOf.messages.includes(message)) {
//             throw new Error('message is not a part of this conversation.');
//         }
//         /// update the message status to deleted = true
//         let deleted = conversationOf.messages.map((msg) => {
//             if (msg._id === message) {
//                 msg.deleted = true;
//             }
//             return msg;
//         }
//         );
//         conversationOf.messages = deleted;
//         await conversationOf.save();
//         return res.status(200).json(conversationOf.messages);
//     } catch (error) {
//         return res.status(500).json({ message: error.message });
//     }
// }