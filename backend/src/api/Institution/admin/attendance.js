import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Attendance } from '../../../models/institution/attendence.js';
import { ClassSchedule } from '../../../models/institution/scheduleClass.js';

export class AttendanceAPI {
  static instance() {
    const router = Router();

    router.get('/list', getAttendanceRecords);
    router.put('/update/:id', updateAttendance);

    return router;
  }
}

const getAttendanceRecords = handleAsyncRequest(async (req, res) => {
  const { batch, module, student, date } = req.query;

  const filter = {};
  const institution = req.user.institution;
  filter.institution = institution;

  if (batch) {
    filter.batch = batch;
  }

  if (module) {
    filter.ClassSchedule = { module };
  }

  if (student) {
    // Find all attendance records for the given student
    filter.attendeeId = student;
  }

  try {
    const attendanceRecords = await Attendance.find(filter)
      .populate({
        path: 'attendeeId',
        select: 'firstName lastName email', // Customize fields based on your Student/Staff/Teacher schema
      })
      .populate({
        path: 'classSchedule',
        select: 'startTime endTime module teacher',
        populate: [
          { path: 'module', select: 'title' },
          {
            path: 'teacher',
            select: 'user',
            populate: { path: 'user', select: 'firstName lastName' },
          },
        ],
      });

    if (!attendanceRecords) {
      throw new APIError(404, 'No attendance records found');
    }

    res.json({ success: true, attendanceRecords });
  } catch (error) {
    console.error(error);
    throw new APIError(500, 'Error retrieving attendance records', error);
  }
});

const updateAttendance = handleAsyncRequest(async (req, res) => {
  const { id } = req.params;
  const { status, time } = req.body;

  // Validate status
  if (!['Present', 'Absent', 'Late'].includes(status)) {
    throw new APIError(400, 'Invalid status value');
  }

  // Validate time if status is 'Late'
  if (status === 'Late' && !time) {
    throw new APIError(400, 'Time of arrival is required when status is Late');
  }

  try {
    // Find and update the attendance record
    const attendance = await Attendance.findByIdAndUpdate(
      id,
      { status, time },
      { new: true, runValidators: true }
    );

    if (!attendance) {
      throw new APIError(404, 'Attendance record not found');
    }

    res.json({ success: true, attendance });
  } catch (error) {
    console.error(error);
    throw new APIError(500, 'Error updating attendance record', error);
  }
});