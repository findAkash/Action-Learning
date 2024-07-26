import { SuperAdmin } from '../../models/superadmin.js';
import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../helpers/handle-async-request.js';

export class SuperAdminAccountAPI {
  static instance() {
    const router = Router();
    router.post('/create', createSuperAdmin);
    router.get('/get', getSuperAdmins);
    router.post('/logout', logout);
    return router;
  }
}

const createSuperAdmin = handleAsyncRequest(async (req, res) => {
  const isExist = await SuperAdmin.findOne({
    email: req.body.email,
  });
  if (isExist) {
    throw new APIError('Super admin already exists', 400);
  }
  const superAdmin = new SuperAdmin(req.body);
  await superAdmin.save();
  return { success: true, superAdmin };
});

const getSuperAdmins = handleAsyncRequest(async () => {
  const superAdmins = await SuperAdmin.find();
  if (!superAdmins) {
    throw new APIError('Super admins not found', 404);
  }
  return { success: true, superAdmins };
});

const logout = handleAsyncRequest(async (req, res) => {
  const user = SuperAdmin.findOne({ _id: req.superAdmin._id });
  if (!user) {
    throw new APIError('Super admin not found', 404);
  }
  user.removeToken(user.tokens.token);
  return { success: true, message: 'Logged out successfully' };
});
