import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { User } from '../../../models/user.js';
import { Student } from '../../../models/institution/student.js';
// import { TeacherAPI } from './teacher.js';
// import { StudentAPI } from './student.js';
// import { BatchAPI } from './batch.js';
// import { EnrollmentAPI } from './enrollment.js';
// import { RoutineAPI } from './routine.js';
import { authMiddleware } from '../../../middleware/authMiddleware.js';
import { ModuleAPI } from './module.js';
import { ScheduledClassAPI } from './scheduledClass.js';
import { Teacher } from '../../../models/institution/teacher.js';

export class InstitutionTeacherAPI {
  static instance() {
    const router = Router();
    router.post('/login', login);
    router.use(authMiddleware('teacher'));
    router.get('/', getMyData);
    router.use('/modules', ModuleAPI.instance());
    router.use('/schedule', ScheduledClassAPI.instance());
    // router.use('/teacher', TeacherAPI.instance());
    // router.use('/student', StudentAPI.instance());
    // router.use('/batch', BatchAPI.instance());
    // router.use('/enrollment', EnrollmentAPI.instance());
    // router.use('routine', RoutineAPI.instance());
    return router;
  }
}

const login = handleAsyncRequest(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email: email, role: 'teacher' });
  if (!user) {
    throw new APIError(400, 'Invalid email or password');
  }
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new APIError(400, 'Invalid email or password');
  }
  const teacher = await Teacher.findOne({ user: user._id });
  const token = await user.generateToken();
  return { success: true, user, teacher };
});

const getMyData = handleAsyncRequest(async (req, res) => {
  const teacher = await Teacher.findOne({ user: req.user })
    .populate('institution')
    .populate('user');

  if (!teacher) {
    throw new APIError(404, 'Teacher not found');
  }

  return { success: true, teacher };
});
