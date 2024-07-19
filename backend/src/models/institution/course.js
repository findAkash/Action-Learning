import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const CourseSchema = new Schema({
  name: { type: String, required: true },
  department_id: {
    type: Schema.Types.ObjectId,
    ref: 'Department',
    required: true,
  },
  level: { type: String, required: true },
  semester: { type: Number, required: true },
  teacher: [{ type: Schema.Types.ObjectId, ref: 'Teacher' }],
});

export const Course = mongoose.model('Course', CourseSchema);
