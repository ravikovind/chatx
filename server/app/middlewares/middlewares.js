import jwt from 'jsonwebtoken';
import mongoose from 'mongoose';

import User from '../models/user.js';


/// body middleware to check if body is empty or not 
export const body = (req, res, next) => {
    console.log(`middleware: {req.body} = ${JSON.stringify(req.body)}`);
    if (Object.keys(req.body).length === 0) {
        return res.status(400).send({ message: 'Invalid Request' });
    }
    next();
}

/// create auth middleware to check if user is authenticated
export const auth = async (req, res, next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ', '');

        if (!token) {
            throw new Error('You are not authorized. Please sign in first.');
        }
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        if (!decoded) {
            throw new Error('You are not authorized. Please sign in first.');
        }
        const id = decoded.id;
        if (!id || id === '' || id === null || id === undefined || id === 'undefined' || id === 'null' || !mongoose.Types.ObjectId.isValid(id)) {
            throw new Error('You are not authorized. Please sign in first.');
        }
        req.user = id;
        next();
    }
    catch (error) {
        res.status(401).send({ error: 'Unauthorized request!' });
    }
}

