import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Routine } from '../../../models/institution/routine.js';

export class RoutineAPI {
  static instance() {
    const router = Router();

    router.post('/create', createRoutine);
    router.get('/list', getRoutines);
    router.get('/:id', getRoutineById);
    router.put('/update/:id', updateRoutine);
    router.delete('/delete/:id', deleteRoutine);

    return router;
  }
}

const createRoutine = handleAsyncRequest(async (req, res) => {
  const {
    moduleId,
    dayOfWeek,
    startTime,
    endTime,
    location,
    teacherId,
    batchId,
  } = req.body;

  // Check if the routine already exists for the given module and time slot
  const existingRoutine = await Routine.findOne({
    moduleId,
    dayOfWeek,
    startTime,
    endTime,
    batchId,
  });
  if (existingRoutine) {
    throw new APIError(
      400,
      'Routine already exists for this module at this time slot for this batch'
    );
  }

  const routine = new Routine({
    moduleId,
    dayOfWeek,
    startTime,
    endTime,
    location,
    teacherId,
    batchId,
  });

  await routine.save();
  res.status(201).json({ success: true, routine });
});

const getRoutines = handleAsyncRequest(async (req, res) => {
  const routines = await Routine.find().populate('moduleId teacherId batchId');
  if (!routines) {
    throw new APIError(404, 'Routines not found');
  }
  res.json({ success: true, routines });
});

const getRoutineById = handleAsyncRequest(async (req, res) => {
  const routine = await Routine.findById(req.params.id).populate(
    'moduleId teacherId batchId'
  );
  if (!routine) {
    throw new APIError(404, 'Routine not found');
  }
  res.json({ success: true, routine });
});

const updateRoutine = handleAsyncRequest(async (req, res) => {
  const routine = await Routine.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  }).populate('moduleId teacherId batchId');
  if (!routine) {
    throw new APIError(404, 'Routine not found');
  }
  res.json({ success: true, routine });
});

const deleteRoutine = handleAsyncRequest(async (req, res) => {
  const routine = await Routine.findByIdAndDelete(req.params.id);
  if (!routine) {
    throw new APIError(404, 'Routine not found');
  }
  res.json({ success: true, message: 'Routine deleted successfully' });
});
