import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { User } from '../../../models/user.js';
import { Student } from '../../../models/institution/student.js';
// import { TeacherAPI } from './teacher.js';
// import { StudentAPI } from './student.js';
// import { CourseAPI } from './course.js';
// import { BatchAPI } from './batch.js';
// import { EnrollmentAPI } from './enrollment.js';
// import { RoutineAPI } from './routine.js';
import { authMiddleware } from '../../../middleware/authMiddleware.js';

export class InstitutionStudentAPI {
  static instance() {
    const router = Router();
    router.post('/login', login);
    router.use(authMiddleware('student'));
    router.get('/:id', getStudentById);
    // router.use('/teacher', TeacherAPI.instance());
    // router.use('/student', StudentAPI.instance());
    // router.use('/course', CourseAPI.instance());
    // router.use('/batch', BatchAPI.instance());
    // router.use('/enrollment', EnrollmentAPI.instance());
    // router.use('routine', RoutineAPI.instance());
    return router;
  }
}

const login = handleAsyncRequest(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email: email, role: 'student' });
  if (!user) {
    throw new APIError(400, 'Invalid email or password');
  }
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new APIError(400, 'Invalid email or password');
  }
  const student = await Student.findOne({ userId: user._id });
  const token = await user.generateToken();
  return { success: true, user, student };
});

const getStudentById = handleAsyncRequest(async (req, res) => {
  const { id } = req.params;
  const user = await User.findById(id);
  if (!user) {
    throw new APIError(404, 'Student not found');
  }
  const student = await Student.findOne({ user: user._id })
    .populate('institution')
    .populate('batch')
    .populate('enrollments')
    .populate('user');
  if (!student) {
    throw new APIError(404, 'Student not found');
  }

  return { success: true, student };
});
