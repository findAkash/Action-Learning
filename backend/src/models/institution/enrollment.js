import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const EnrollmentSchema = new Schema({
  student_id: { type: Schema.Types.ObjectId, ref: 'Student', required: true },
  course_id: { type: Schema.Types.ObjectId, ref: 'Course', required: true },
  semester: { type: Number, required: true },
  grade: { type: String },
});

export const Enrollment = mongoose.model('Enrollment', EnrollmentSchema);
