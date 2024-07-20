import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Course } from '../../../models/institution/course.js';

export class CourseAPI {
  static instance() {
    const router = Router();

    router.post('/create', createCourse);
    router.get('/list', getCourses);
    router.get('/:id', getCourseById);
    router.put('/update/:id', updateCourse);
    router.delete('/delete/:id', deleteCourse);

    return router;
  }
}

const createCourse = handleAsyncRequest(async (req, res) => {
  const { name, department, code, credit, duration, level, semester, teacher } =
    req.body;

  // Check if the course already exists
  const isExist = await Course.findOne({ name, department, semester });
  if (isExist) {
    throw new APIError(400, 'Course already exists');
  }

  const institution = req.user.institution;

  const course = new Course({
    name,
    department,
    code,
    credit,
    duration,
    level,
    semester,
    teacher,
    institution,
  });

  await course.save();
  res.status(201).json({ success: true, course });
});

const getCourses = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const courses = await Course.find({ institution: institution }).populate(
    'department teacher institution'
  );
  if (!courses) {
    throw new APIError(404, 'Courses not found');
  }
  res.json({ success: true, courses });
});

const getCourseById = handleAsyncRequest(async (req, res) => {
  const course = await Course.findById(req.params.id).populate(
    'department teacher institution'
  );
  if (!course) {
    throw new APIError(404, 'Course not found');
  }
  res.json({ success: true, course });
});

const updateCourse = handleAsyncRequest(async (req, res) => {
  const updatedCourseData = req.body;

  const course = await Course.findByIdAndUpdate(
    req.params.id,
    updatedCourseData,
    {
      new: true,
      runValidators: true,
    }
  ).populate('department teacher institution');
  if (!course) {
    throw new APIError(404, 'Course not found');
  }
  res.json({ success: true, course });
});

const deleteCourse = handleAsyncRequest(async (req, res) => {
  const course = await Course.findByIdAndDelete(req.params.id);
  if (!course) {
    throw new APIError(404, 'Course not found');
  }
  res.json({ success: true, message: 'Course deleted successfully' });
});