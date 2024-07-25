import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';

import { Module } from '../../../models/institution/module.js';
import { Enrollment } from '../../../models/institution/enrollment.js';
import { Course } from '../../../models/institution/course.js';

export class ModuleAPI {
  static instance() {
    const router = Router();

    router.get('/', getModules);

    return router;
  }
}

const getModules = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const modules = await Module.find({
    institution: institution,
    teachers: { $elemMatch: { teacher: req.teacher } },
  }).populate('teachers institution');
  if (!modules) {
    throw new APIError(404, 'Modules not found');
  }
  res.json({ success: true, modules });
});
