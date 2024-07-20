import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Enrollment } from '../../../models/institution/enrollment.js';

export class EnrollmentAPI {
  static instance() {
    const router = Router();

    router.post('/create', createEnrollment);
    router.get('/list', getEnrollments);
    router.get('/:id', getEnrollmentById);
    router.put('/update/:id', updateEnrollment);
    router.delete('/delete/:id', deleteEnrollment);

    return router;
  }
}

const createEnrollment = handleAsyncRequest(async (req, res) => {
  const { studentId, courseId, semester, grade } = req.body;

  // Check if the enrollment already exists
  const isExist = await Enrollment.findOne({ studentId, courseId, semester });
  if (isExist) {
    throw new APIError(400, 'Enrollment already exists');
  }

  const enrollment = new Enrollment({
    studentId,
    courseId,
    semester,
    grade,
  });

  await enrollment.save();
  res.status(201).json({ success: true, enrollment });
});

const getEnrollments = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const enrollments = await Enrollment.find({
    institution: institution,
  }).populate('studentId courseId');
  if (!enrollments) {
    throw new APIError(404, 'Enrollments not found');
  }
  res.json({ success: true, enrollments });
});

const getEnrollmentById = handleAsyncRequest(async (req, res) => {
  const enrollment = await Enrollment.findById(req.params.id).populate(
    'studentId courseId'
  );
  if (!enrollment) {
    throw new APIError(404, 'Enrollment not found');
  }
  res.json({ success: true, enrollment });
});

const updateEnrollment = handleAsyncRequest(async (req, res) => {
  const enrollment = await Enrollment.findByIdAndUpdate(
    req.params.id,
    req.body,
    {
      new: true,
      runValidators: true,
    }
  ).populate('studentId courseId');
  if (!enrollment) {
    throw new APIError(404, 'Enrollment not found');
  }
  res.json({ success: true, enrollment });
});

const deleteEnrollment = handleAsyncRequest(async (req, res) => {
  const enrollment = await Enrollment.findByIdAndDelete(req.params.id);
  if (!enrollment) {
    throw new APIError(404, 'Enrollment not found');
  }
  res.json({ success: true, message: 'Enrollment deleted successfully' });
});
