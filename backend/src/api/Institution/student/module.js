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
  const enrollment = await Enrollment.find({ student: req.student });
  if (!enrollment) {
    throw new APIError(404, 'Student is not enrolled in any course');
  }

  const courses = await Course.find({
    institution: institution,
    _id: { $in: enrollment.map((e) => e.course) },
  });
  if (!courses) {
    throw new APIError(404, 'Courses not found');
  }
  const modules = await Module.find({
    institution: institution,
    batch: req.student.batch,
    course: { $in: courses.map((e) => e._id) },
  }).populate('teachers institution');
  if (!modules) {
    throw new APIError(404, 'Modules not found');
  }
  res.json({ success: true, modules });
});
