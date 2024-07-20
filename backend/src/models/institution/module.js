import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const TeacherRoleSchema = new Schema({
  teacher: { type: Schema.Types.ObjectId, ref: 'Teacher', required: true },
  role: { type: String, required: true }, // e.g., 'module leader', 'teacher'
});

const ModuleSchema = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  teachers: [TeacherRoleSchema], // Embedded sub-document for each teacher
  credit: { type: Number, required: true },
  institution: {
    type: Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
  batch: { type: Schema.Types.ObjectId, ref: 'Batch', required: true },
  course: {
    type: Schema.Types.ObjectId,
    ref: 'Course',
    required: true,
  },
});

export const Module = mongoose.model('Module', ModuleSchema);