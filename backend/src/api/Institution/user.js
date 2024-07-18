import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../helpers/handle-async-request.js';
import { User } from '../../models/users.js';

export class UserInstitutionAPI {
  static instance() {
    const router = Router();

    router.post('/create', createUser);
    router.get('/list', getUsers);
    // router.put('/update/:id', updateUser);
    // router.delete('/delete/:id', deleteUser);

    return router;
  }
}

const createUser = handleAsyncRequest(async (req, res) => {
  const isExist = await User.findOne({
    email: req.body.email,
  });
  if (isExist) {
    throw new APIError(400, 'User already exists');
  }
  const user = new User(req.body);
  await user.save();
  res.status(201).json(user);
  //   return {
  //     success: true,
  //     user,
  //   };
});

const getUsers = handleAsyncRequest(async (req) => {
  const users = await User.find();
  if (!users) {
    throw new APIError(404, 'Users not found');
  }
  return { success: true, users };
});
