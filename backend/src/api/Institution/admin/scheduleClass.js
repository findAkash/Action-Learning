import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { ClassSchedule } from '../../../models/institution/scheduleClass.js';

export class ClassScheduleAPI {
  static instance() {
    const router = Router();

    router.post('/create', createClassSchedules);
    router.get('/list', getClassSchedules);
    router.get('/:id', getClassScheduleById);
    router.put('/update/:id', updateClassSchedule);
    router.delete('/delete/:id', deleteClassSchedule);

    return router;
  }
}

const createClassSchedules = handleAsyncRequest(async (req, res) => {
  const schedules = req.body;

  if (!Array.isArray(schedules) || schedules.length === 0) {
    throw new APIError(400, 'Request body must be an array of class schedules');
  }

  const institution = req.user.institution;

  const classScheduleDocuments = schedules.map((schedule) => ({
    ...schedule,
    institution,
  }));

  try {
    const createdSchedules = await ClassSchedule.insertMany(
      classScheduleDocuments
    );
    res.status(201).json({ success: true, classSchedules: createdSchedules });
  } catch (error) {
    console.error(error);
    throw new APIError(500, 'Error creating class schedules', error);
  }
});

const getClassSchedules = handleAsyncRequest(async (req, res) => {
  const { classroom, module, teacher, batch, course } = req.query;

  const filter = {};

  if (classroom) {
    filter.location = classroom;
  }
  if (module) {
    filter.module = module;
  }
  if (teacher) {
    filter.teacher = teacher;
  }
  if (batch) {
    filter.batch = batch;
  }
  if (course) {
    filter.course = course;
  }

  const classSchedules = await ClassSchedule.find(filter).populate(
    'module teacher batch institution'
  );

  if (!classSchedules) {
    throw new APIError(404, 'Class schedules not found');
  }
  res.json({ success: true, classSchedules });
});

const getClassScheduleById = handleAsyncRequest(async (req, res) => {
  const classSchedule = await ClassSchedule.findById(req.params.id).populate(
    'module teacher batch institution'
  );

  if (!classSchedule) {
    throw new APIError(404, 'Class schedule not found');
  }
  res.json({ success: true, classSchedule });
});

const updateClassSchedule = handleAsyncRequest(async (req, res) => {
  const updatedScheduleData = req.body;

  const classSchedule = await ClassSchedule.findByIdAndUpdate(
    req.params.id,
    updatedScheduleData,
    {
      new: true,
      runValidators: true,
    }
  ).populate('module teacher batch institution');

  if (!classSchedule) {
    throw new APIError(404, 'Class schedule not found');
  }
  res.json({ success: true, classSchedule });
});

const deleteClassSchedule = handleAsyncRequest(async (req, res) => {
  const classSchedule = await ClassSchedule.findByIdAndDelete(req.params.id);

  if (!classSchedule) {
    throw new APIError(404, 'Class schedule not found');
  }
  res.json({ success: true, message: 'Class schedule deleted successfully' });
});
