import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Student } from '../../../models/institution/student.js';
import { User } from '../../../models/user.js';
import mongoose from 'mongoose';

export class StudentAPI {
  static instance() {
    const router = Router();

    router.post('/create', createStudent);
    router.get('/list', getStudents);
    router.get('/:id', getStudentById);
    router.put('/update/:id', updateStudent);
    router.delete('/delete/:id', deleteStudent);

    return router;
  }
}

const createStudent = handleAsyncRequest(async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const { email, password, firstName, lastName, institutionId, batch } =
      req.body;

    // Check if the user already exists
    const isUserExist = await User.findOne({ email });
    if (isUserExist) {
      throw new APIError(400, 'User already exists');
    }

    // Create the user
    const user = new User({
      email,
      password,
      firstName,
      lastName,
      role: 'student',
      institution: institutionId,
    });

    await user.save({ session });

    // Create the student
    const student = new Student({
      userId: user._id,
      institutionId,
      batch,
      enrollments: [],
    });

    await student.save({ session });

    await session.commitTransaction();
    session.endSession();

    res.status(201).json({ success: true, user, student });
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    throw error;
  }
});

const getStudents = handleAsyncRequest(async (req, res) => {
  const students = await Student.find().populate(
    'userId institutionId batch enrollments'
  );
  if (!students) {
    throw new APIError(404, 'Students not found');
  }
  res.json({ success: true, students });
});

const getStudentById = handleAsyncRequest(async (req, res) => {
  const student = await Student.findById(req.params.id).populate(
    'userId institutionId batch enrollments'
  );
  if (!student) {
    throw new APIError(404, 'Student not found');
  }
  res.json({ success: true, student });
});

const updateStudent = handleAsyncRequest(async (req, res) => {
  const student = await Student.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  }).populate('userId institutionId batch enrollments');
  if (!student) {
    throw new APIError(404, 'Student not found');
  }
  res.json({ success: true, student });
});

const deleteStudent = handleAsyncRequest(async (req, res) => {
  const student = await Student.findByIdAndDelete(req.params.id);
  if (!student) {
    throw new APIError(404, 'Student not found');
  }
  res.json({ success: true, message: 'Student deleted successfully' });
});
