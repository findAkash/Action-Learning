import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const classScheduleSchema = new Schema({
  module: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Module',
    required: true,
  },
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Teacher',
    required: true,
  },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  dayOfWeek: {
    type: String,
    enum: [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    required: true,
  },
  location: { type: String },
  batch: { type: mongoose.Schema.Types.ObjectId, ref: 'Batch', required: true },
  institution: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
});

export const ClassSchedule = mongoose.model(
  'ClassSchedule',
  classScheduleSchema
);
