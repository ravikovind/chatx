import User from "../models/user.js";

import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

/// signUp
export const signUp = async (req, res) => {
  const {
    email,
    password,
    name,
    verified,
    phone,
    gender,
    dateOfBirth,
    avatar,
    status,
  } = req.body;
  try {
    /// decrypt the password
    const hashedPassword = await bcrypt.hash(password, 10);
    /// findOne user by email
    const user = await User.findOne({ email });
    /// if user already exists
    if (!user) {
      let update = {};
      update.email = email;
      update.password = hashedPassword;
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
      /// create a new user
      let newUser = await User.create(update);
      /// create a token never expires
      const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET, {
        expiresIn: "100y",
      });

      const result = {
        ...newUser._doc,
        accessToken: token,
      };

      /// return the saved user
      return res.status(201).json(result);
    }
    /// throw error if user already exists
    throw new Error("User already exists. Please sign in.");
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};

/// signIn
export const signIn = async (req, res) => {
  const { email, password } = req.body;
  try {
    /// findOne user by email
    const user = await User.findOne({ email });
    /// if user exists
    if (user) {
      /// compare the password sent with the request with the user's password
      const matched = await bcrypt.compare(password, user.password);
      /// if password matches
      if (matched) {
        /// create a token never expires
        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
          expiresIn: "100y",
        });

        const result = {
          ...user._doc,
          accessToken: token,
        };

        return res.status(200).json(result);
      }
      /// throw error if password does not match
      throw new Error("Password is incorrect.");
    }

    /// throw error if user does not exist
    throw new Error("We could not find your account.");
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};
