import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Department } from '../../../models/institution/department.js';

export class DepartmentAPI {
  static instance() {
    const router = Router();

    router.post('/create', createDepartment);
    router.get('/list', getDepartments);
    router.get('/:id', getDepartmentById);
    router.put('/update/:id', updateDepartment);
    router.delete('/delete/:id', deleteDepartment);

    return router;
  }
}

const createDepartment = handleAsyncRequest(async (req, res) => {
  const { name, courses } = req.body;

  const institution = req.user.institution;
  // Check if the department already exists for the given name and institution
  const existingDepartment = await Department.findOne({ name, institution });
  if (existingDepartment) {
    throw new APIError(400, 'Department already exists for this institution');
  }

  const department = new Department({
    name,
    institution,
    courses,
  });

  await department.save();
  res.status(201).json({ success: true, department });
});

const getDepartments = handleAsyncRequest(async (req, res) => {
  const institution = req.user.institution;
  const departments = await Department.find({ institution: institution })
    .populate('institution')
    .populate('courses');
  if (!departments) {
    throw new APIError(404, 'Departments not found');
  }
  res.json({ success: true, departments });
});

const getDepartmentById = handleAsyncRequest(async (req, res) => {
  const department = await Department.findById(req.params.id)
    .populate('institution')
    .populate('courses');
  if (!department) {
    throw new APIError(404, 'Department not found');
  }
  res.json({ success: true, department });
});

const updateDepartment = handleAsyncRequest(async (req, res) => {
  const department = await Department.findByIdAndUpdate(
    req.params.id,
    req.body,
    {
      new: true,
      runValidators: true,
    }
  )
    .populate('institution')
    .populate('courses');
  if (!department) {
    throw new APIError(404, 'Department not found');
  }
  res.json({ success: true, department });
});

const deleteDepartment = handleAsyncRequest(async (req, res) => {
  const department = await Department.findByIdAndDelete(req.params.id);
  if (!department) {
    throw new APIError(404, 'Department not found');
  }
  res.json({ success: true, message: 'Department deleted successfully' });
});

export default DepartmentAPI;
