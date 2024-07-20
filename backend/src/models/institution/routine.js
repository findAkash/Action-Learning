import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const RoutineSchema = new Schema({
  moduleId: {
    type: Schema.Types.ObjectId,
    ref: 'Module',
    required: true,
  },
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
  startTime: {
    type: String, // Format: HH:MM
    required: true,
  },
  endTime: {
    type: String, // Format: HH:MM
    required: true,
  },
  location: {
    type: String, // Optional field for location (e.g., classroom number)
    required: false,
  },
  teacherId: {
    type: Schema.Types.ObjectId,
    ref: 'Teacher',
    required: false,
  },
  batchId: {
    type: Schema.Types.ObjectId,
    ref: 'Batch',
    required: true,
  },
  institution: {
    type: Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
});

export const Routine = mongoose.model('Routine', RoutineSchema);
