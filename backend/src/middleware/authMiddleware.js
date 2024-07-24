import jwt from 'jsonwebtoken';
import { User } from '../models/user.js';
import { SuperAdmin } from '../models/superadmin.js';
import { CONFIG } from '../../config/confg.js';
import {
  handleAsyncRequest,
  APIError,
} from '../helpers/handle-async-request.js';
import { Student } from '../models/institution/student.js';
import { Teacher } from '../models/institution/teacher.js';

export const authMiddleware = (type) => async (req, res, next) => {
  try {
    const token = req.header('Authorization');
    if (!token) {
      console.log('No token');
      throw new APIError(401, 'Please authenticate');
    }
    const cleanToken = token.replace('Bearer ', '');

    const decoded = jwt.verify(cleanToken, CONFIG.SECRET);
    if (!decoded) {
      throw new APIError(401, 'Invalid token');
    }
    if (type === 'superadmin') {
      const superAdmin = await SuperAdmin.findOne({
        _id: decoded._id,
        'tokens.token': cleanToken,
      });
      if (!superAdmin) {
        throw new APIError(401, 'Super Admin not found');
      }
      req.superAdmin = superAdmin;
    } else if (type === 'admin') {
      const user = await User.findOne({
        _id: decoded._id,
      });
      console.log(user);
      if (!user) {
        throw new APIError(401, 'User not found');
      }
      if (user.role !== 'admin') {
        throw new APIError(401, 'Unauthorized');
      }
      req.user = user;
    } else if (type === 'student') {
      const user = await User.findOne({
        _id: decoded._id,
      });
      const student = await Student.findOne({ user: user._id });
      if (!user && !student) {
        throw new APIError(401, 'User not found');
      }

      if (user.role !== 'student') {
        throw new APIError(401, 'Unauthorized');
      }
      req.user = user;
      req.student = student;
    } else if (type === 'teacher') {
      const user = await User.findOne({
        _id: decoded._id,
      });
      if (!user) {
        throw new APIError(401, 'User not found');
      }

      if (user.role !== 'teacher') {
        throw new APIError(401, 'Unauthorized');
      }
      const teacher = await Teacher.findOne({ user: user._id });
      req.user = user;
      req.teacher = teacher;
    } else {
      throw new APIError(401, 'Invalid token');
    }
    req.token = token;
    next(); // Call next to pass control to the next middleware function
  } catch (error) {
    // Handle the error directly within the middleware
    console.log(error);
    res.status(error.status || 500).json({ message: error.message });
  }
};
