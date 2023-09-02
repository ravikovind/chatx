import express from 'express';
import { signIn, signUp } from '../controllers/auth.js';

const AuthRouter = express.Router();

AuthRouter.post('/signUp', signUp);
AuthRouter.post('/signIn', signIn);

export default AuthRouter;

