import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../helpers/handle-async-request.js';
import { User } from '../../models/users.js';
import { UserInstitutionAPI } from './user.js';

export class InstitutionAPI {
  static instance() {
    const router = Router();
    router.post('/login', login);
    router.use('/user', UserInstitutionAPI.instance());
    return router;
  }
}

const login = handleAsyncRequest(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user) {
    throw new APIError(400, 'Invalid email or password');
  }
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new APIError(400, 'Invalid email or password');
  }
  const token = await user.generateToken();
  return { success: true, user };
});
