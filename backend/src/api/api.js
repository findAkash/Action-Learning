import { UserInstitutionAPI } from './Institution/user.js';
import { Router } from 'express';
import { SuperAdmin } from '../models/superadmin.js';
import { SuperAdminAPI } from './SuperAdmin/index.js';
import { InstitutionAPI } from './Institution/index.js';

export class API {
  static instance() {
    const router = Router();
    router.use('/superadmin', SuperAdminAPI.instance());
    router.use('/user', UserInstitutionAPI.instance());
    router.use('/institution', InstitutionAPI.instance());
    return router;
  }
}

// create default super admin
const createDefaultSuperAdmin = async () => {
  const superAdmin = await SuperAdmin.findOne();
  if (!superAdmin) {
    const admin = new SuperAdmin({
      email: 'admin@gmail.com',
      password: 'password',
    });
    await admin.save();
  }
};
createDefaultSuperAdmin();
