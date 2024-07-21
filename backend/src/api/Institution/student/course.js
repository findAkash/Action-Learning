import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';

import { Course } from '../../../models/institution/course.js';
import { Enrollment } from '../../../models/institution/enrollment.js';

export class CourseAPI {
  static instance() {
    const router = Router();

    router.get('/', getCourses);

    return router;
  }
}

const getCourses = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const enrollment = await Enrollment.find({ student: req.student });
  if (!enrollment) {
    throw new APIError(404, 'Student is not enrolled in any course');
  }
  const courses = await Course.find({
    institution: institution,
    _id: { $in: enrollment.map((e) => e.course) },
  }).populate('department teacher institution');
  if (!courses) {
    throw new APIError(404, 'Courses not found');
  }
  res.json({ success: true, courses });
});
