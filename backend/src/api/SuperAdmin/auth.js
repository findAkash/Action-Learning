import { SuperAdmin } from '../../models/superadmin.js';
import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../helpers/handle-async-request.js';

export class SuperAdminAuthAPI {
  static instance() {
    const router = Router();
    router.post('/login', login);
    return router;
  }
}

const login = handleAsyncRequest(async (req, res) => {
  const { email, password } = req.body;
  const user = await SuperAdmin.findOne({ email });
  if (!user) {
    throw new APIError(400, 'Super admin not found');
  }
  const isMatch = await user.comparePassword(password);
  console.log(isMatch);
  if (!isMatch) {
    throw new APIError(400, 'Invalid email or password');
  }
  const token = await user.generateToken();
  return { success: true, user };
});
