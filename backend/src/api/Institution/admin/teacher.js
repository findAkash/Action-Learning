import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Teacher } from '../../../models/institution/teacher.js';
import { User } from '../../../models/user.js';
import mongoose from 'mongoose';

export class TeacherAPI {
  static instance() {
    const router = Router();

    router.post('/create', createTeacher);
    router.get('/list', getTeachers);
    router.get('/:id', getTeacherById);
    router.put('/update/:id', updateTeacher);
    router.delete('/delete/:id', deleteTeacher);

    return router;
  }
}

const createTeacher = handleAsyncRequest(async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const { email, password, firstName, lastName, modules } = req.body;

    // Check if the user already exists
    const isUserExist = await User.findOne({ email });
    if (isUserExist) {
      throw new APIError(400, 'User already exists');
    }

    const institutionId = req.user.institution;
    // Create the user
    const user = new User({
      email,
      password,
      firstName,
      lastName,
      role: 'teacher',
      institution: institutionId,
    });

    await user.save({ session });

    // Create the teacher
    const teacher = new Teacher({
      user: user._id,
      institution: institutionId,
      modules,
    });

    await teacher.save({ session });

    await session.commitTransaction();
    session.endSession();

    res.status(201).json({ success: true, user, teacher });
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    throw error;
  }
});

const getTeachers = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const teachers = await Teacher.find({ institution: institution }).populate(
    'user institution'
  );
  if (!teachers) {
    throw new APIError(404, 'Teachers not found');
  }
  res.json({ success: true, teachers });
});

const getTeacherById = handleAsyncRequest(async (req, res) => {
  const teacher = await Teacher.findById(req.params.id).populate(
    'user institution'
  );
  if (!teacher) {
    throw new APIError(404, 'Teacher not found');
  }
  res.json({ success: true, teacher });
});

const updateTeacher = handleAsyncRequest(async (req, res) => {
  const teacher = await Teacher.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  }).populate('user institution');
  if (!teacher) {
    throw new APIError(404, 'Teacher not found');
  }
  res.json({ success: true, teacher });
});

const deleteTeacher = handleAsyncRequest(async (req, res) => {
  const teacher = await Teacher.findByIdAndDelete(req.params.id);
  if (!teacher) {
    throw new APIError(404, 'Teacher not found');
  }
  res.json({ success: true, message: 'Teacher deleted successfully' });
});
