import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const AttendanceSchema = new Schema({
  attendeeId: {
    type: Schema.Types.ObjectId,
    refPath: 'attendeeModel', // Dynamically reference different models
    required: true,
  },
  attendeeModel: {
    type: String,
    required: true,
    enum: ['Student', 'Staff', 'Teacher'], // Enum to restrict the values to specific models
  },
  date: {
    type: Date,
    required: true,
  },
  status: {
    type: String,
    required: true,
    enum: ['Present', 'Absent', 'Late'], // Enum to restrict possible statuses
  },
  time: {
    type: String, // Store time as string in 'HH:mm' format
  },
});

// Add a pre-save hook to ensure `time` is provided when `status` is 'Late'
AttendanceSchema.pre('save', function (next) {
  if (this.status === 'Late' && !this.time) {
    return next(new Error('Time of arrival is required when status is Late.'));
  }
  next();
});

module.exports = mongoose.model('Attendance', AttendanceSchema);
