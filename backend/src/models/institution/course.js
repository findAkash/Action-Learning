import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const CourseSchema = new Schema({
  name: { type: String, required: true },
  department: {
    type: Schema.Types.ObjectId,
    ref: 'Department',
    required: true,
  },
  code: { type: String, required: true },
  credit: { type: Number, required: true },
  duration: { type: Number, required: true }, // Duration in months
  level: { type: String, required: true },
  semester: { type: Number, required: true },
  teacher: [{ type: Schema.Types.ObjectId, ref: 'Teacher' }],
  institution: { type: Schema.Types.ObjectId, ref: 'Institutions' },
});

export const Course = mongoose.model('Course', CourseSchema);