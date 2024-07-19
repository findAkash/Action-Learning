import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Module } from '../../../models/institution/module.js';

export class ModuleAPI {
  static instance() {
    const router = Router();

    router.post('/create', createModule);
    router.get('/list', getModules);
    router.get('/:id', getModuleById);
    router.put('/update/:id', updateModule);
    router.delete('/delete/:id', deleteModule);

    return router;
  }
}

const createModule = handleAsyncRequest(async (req, res) => {
  const {
    title,
    description,
    teachers,
    credit,
    institutionId,
    batchId,
    course,
  } = req.body;

  // Check if the module already exists
  const isExist = await Module.findOne({ title, course });
  if (isExist) {
    throw new APIError(400, 'Module already exists');
  }

  const module = new Module({
    title,
    description,
    teachers,
    credit,
    institutionId,
    batchId,
    course,
  });

  await module.save();
  res.status(201).json({ success: true, module });
});

const getModules = handleAsyncRequest(async (req, res) => {
  const modules = await Module.find().populate(
    'institutionId batchId course teachers.teacherId'
  );
  if (!modules) {
    throw new APIError(404, 'Modules not found');
  }
  res.json({ success: true, modules });
});

const getModuleById = handleAsyncRequest(async (req, res) => {
  const module = await Module.findById(req.params.id).populate(
    'institutionId batchId course teachers.teacherId'
  );
  if (!module) {
    throw new APIError(404, 'Module not found');
  }
  res.json({ success: true, module });
});

const updateModule = handleAsyncRequest(async (req, res) => {
  const module = await Module.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  }).populate('institutionId batchId course teachers.teacherId');
  if (!module) {
    throw new APIError(404, 'Module not found');
  }
  res.json({ success: true, module });
});

const deleteModule = handleAsyncRequest(async (req, res) => {
  const module = await Module.findByIdAndDelete(req.params.id);
  if (!module) {
    throw new APIError(404, 'Module not found');
  }
  res.json({ success: true, message: 'Module deleted successfully' });
});
