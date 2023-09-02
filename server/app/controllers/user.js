import User from "../models/user.js";

export const updateUser = async (req, res) => {
    let id = req.user;
    const { name, verified, phone, gender, avatar, dateOfBirth, status } = req.body;
    let update = {};
    if (name) update.name = name;
    if (verified) update.verified = verified;
    if (phone) update.phone = phone;
    if (gender) update.gender = gender;
    if (dateOfBirth) {
        const dateOf = new Date(dateOfBirth);
        update.dateOfBirth = dateOf;
    }
    if (avatar) update.avatar = avatar;
    if (status) update.status = status;
    try {
        const updatedUser = await User.findOneAndUpdate({ _id: id }, update, { new: true });
        if (updatedUser) {
            return res.status(200).json(updatedUser);
        }
        throw new Error('User not found.');
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

/// user full text search by name
export const searchUser = async (req, res) => {
    const { name } = req.query;
    try {
        const users = await User.find({ name: { $regex: `${name}`, $options: 'i' } });
        if (users) {
            return res.status(200).json(users);
        }
        throw new Error('User not found.');
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}