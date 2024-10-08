import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { User } from '../../../models/user.js';
import { TeacherAPI } from './teacher.js';
import { StudentAPI } from './student.js';
import { CourseAPI } from './course.js';
import { BatchAPI } from './batch.js';
import { EnrollmentAPI } from './enrollment.js';
import { authMiddleware } from '../../../middleware/authMiddleware.js';
import DepartmentAPI from './department.js';
import { ModuleAPI } from './module.js';
import { ClassScheduleAPI } from './scheduleClass.js';
import { AttendanceAPI } from './attendance.js';
import { Course } from '../../../models/institution/course.js';
import { Batch } from '../../../models/institution/batch.js';
import { Student } from '../../../models/institution/student.js';
import { Teacher } from '../../../models/institution/teacher.js';
import { Department } from '../../../models/institution/department.js';
import { Module } from '../../../models/institution/module.js';
import { Enrollment } from '../../../models/institution/enrollment.js';

export class InstitutionAdminAPI {
  static instance() {
    const router = Router();
    router.post('/login', login);
    router.use(authMiddleware('admin'));
    router.get('/dashboard', getDataForDashboard);
    router.use('/teacher', TeacherAPI.instance());
    router.use('/student', StudentAPI.instance());
    router.use('/course', CourseAPI.instance());
    router.use('/batch', BatchAPI.instance());
    router.use('/enrollment', EnrollmentAPI.instance());
    router.use('/department', DepartmentAPI.instance());
    router.use('/module', ModuleAPI.instance());
    router.use('/routine', ClassScheduleAPI.instance());
    router.use('/attendance', AttendanceAPI.instance());
    return router;
  }
}

const login = handleAsyncRequest(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user) {
    throw new APIError(400, 'Invalid email or password');
  }
  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    throw new APIError(400, 'Invalid email or password');
  }
  const token = await user.generateToken();
  return { success: true, user };
});

// for dashboard
const getDataForDashboard = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;

  try {
    const countCourse = await Course.countDocuments({ institution });
    const countBatch = await Batch.countDocuments({
      institutionId: institution,
    });
    const countStudent = await Student.countDocuments({ institution });
    const countTeacher = await Teacher.countDocuments({ institution });
    const countDepartment = await Department.countDocuments({ institution });
    const countModule = await Module.countDocuments({ institution });

    return {
      success: true,
      data: {
        countCourse,
        countBatch,
        countStudent,
        countTeacher,
        countDepartment,
        countModule,
      },
    };
  } catch (error) {
    console.log(error);
    throw new APIError(400, 'Error fetching data');
  }
});
