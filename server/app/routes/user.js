import express from 'express';

import { auth, body } from '../middlewares/middlewares.js';
import { updateUser, searchUser } from '../controllers/user.js';
import { conversations, createConversation } from '../controllers/conversation.js';

const UserRouter = express.Router();

/// user routes
UserRouter.put('/update', auth, body, updateUser);
UserRouter.get('/search', auth, searchUser);

/// conversation routes
UserRouter.get('/conversations', auth, conversations);
UserRouter.post('/conversation', body, auth, createConversation);

export default UserRouter;