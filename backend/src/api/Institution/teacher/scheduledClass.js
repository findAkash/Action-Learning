import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';

import { Module } from '../../../models/institution/module.js';
import { Enrollment } from '../../../models/institution/enrollment.js';
import { Course } from '../../../models/institution/course.js';
import { ClassSchedule } from '../../../models/institution/scheduleClass.js';

export class ScheduledClassAPI {
  static instance() {
    const router = Router();

    router.get(':module_id', getClassForModule);

    return router;
  }
}

const getClassForModule = handleAsyncRequest(async (req, res) => {
  console.log(req.teacher);
  const institution = req.user.institution;
  const scheduledClass = await ClassSchedule.findOne({
    institution: institution,
    module: req.params.module_id,
    teacher: req.teacher._id,
  }).populate('module institution batch');

  if (!scheduledClass) {
    throw new APIError(404, 'Scheduled class not found');
  }
  res.json({ success: true, scheduledClass });
});
