import { Router } from 'express';
import { SuperAdminAuthAPI } from './auth.js';
import { SuperAdminAccountAPI } from './account.js';
import { AdminInstitutionAPI } from './institution.js';
import { authMiddleware } from '../../middleware/authMiddleware.js';

export class SuperAdminAPI {
  static instance() {
    const router = Router();

    router.use('/auth', SuperAdminAuthAPI.instance());

    // Check Authentication for the following routes
    router.use(authMiddleware('superadmin'));

    router.use('', SuperAdminAccountAPI.instance());
    router.use('/institution', AdminInstitutionAPI.instance());
    return router;
  }
}
