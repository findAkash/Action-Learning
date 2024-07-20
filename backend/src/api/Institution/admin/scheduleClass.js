import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { ClassSchedule } from '../../../models/institution/scheduleClass.js';
import moment from 'moment';
import { Attendance } from '../../../models/institution/attendence.js';
import { Student } from '../../../models/institution/student.js';
import mongoose from 'mongoose';

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

  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const createdSchedules = await ClassSchedule.insertMany(
      classScheduleDocuments,
      { session }
    );

    // Generate attendance records for each created class schedule
    for (const schedule of createdSchedules) {
      const students = await Student.find({
        batch: schedule.batch,
        institution,
      }).session(session);

      const attendanceRecords = students.map((student) => ({
        attendeeId: student._id,
        attendeeModel: 'Student',
        date: moment(schedule.startTime).startOf('day').toDate(),
        status: 'Absent', // Default status, can be updated later
        classSchedule: schedule._id,
        institution,
        batch: schedule.batch,
      }));

      await Attendance.insertMany(attendanceRecords, { session });
    }

    await session.commitTransaction();
    session.endSession();
    res.status(201).json({ success: true, classSchedules: createdSchedules });
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    console.error(error);
    throw new APIError(500, 'Error creating class schedules', error);
  }
});

const getClassSchedules = handleAsyncRequest(async (req, res) => {
  const { classroom, module, teacher, batch, course, date, mode } = req.query;

  const filter = {};
  const institution = req.user.institution;
  filter.institution = institution;

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

  if (date) {
    let startDate;
    let endDate;

    if (moment(date, 'YYYY-MM-DD', true).isValid()) {
      // Handle specific date
      startDate = moment(date).startOf('day').toDate();
      endDate =
        mode === 'weekly'
          ? moment(date).endOf('week').toDate()
          : moment(date).endOf('day').toDate();
    } else {
      // Handle predefined ranges
      switch (date.toLowerCase()) {
        case 'today':
          startDate = moment().startOf('day').toDate();
          endDate = moment().endOf('day').toDate();
          break;
        case 'tomorrow':
          startDate = moment().add(1, 'day').startOf('day').toDate();
          endDate = moment().add(1, 'day').endOf('day').toDate();
          break;
        case 'yesterday':
          startDate = moment().subtract(1, 'day').startOf('day').toDate();
          endDate = moment().subtract(1, 'day').endOf('day').toDate();
          break;
        case 'thisweek':
          startDate = moment().startOf('week').toDate();
          endDate = moment().endOf('week').toDate();
          break;
        case 'nextweek':
          startDate = moment().add(1, 'week').startOf('week').toDate();
          endDate = moment().add(1, 'week').endOf('week').toDate();
          break;
        case 'lastweek':
          startDate = moment().subtract(1, 'week').startOf('week').toDate();
          endDate = moment().subtract(1, 'week').endOf('week').toDate();
          break;
        default:
          throw new APIError(400, 'Invalid date format');
      }
    }

    filter.startTime = { $gte: startDate, $lte: endDate };
  }

  const classSchedules = await ClassSchedule.find(filter)
    .populate({
      path: 'module',
      select: 'title description credit',
    })
    .populate({
      path: 'batch',
      select: 'batchName',
    })
    .populate({
      path: 'teacher',
      select: 'user',
      populate: {
        path: 'user',
        select: 'firstName lastName email',
      },
    });

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