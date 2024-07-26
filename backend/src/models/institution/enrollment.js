import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const EnrollmentSchema = new Schema(
  {
    student: { type: Schema.Types.ObjectId, ref: 'Student', required: true },
    course: { type: Schema.Types.ObjectId, ref: 'Course', required: true },
    fee: { type: Number, required: true },
    discount: { type: Number, default: 0 },
    institution: {
      type: Schema.Types.ObjectId,
      ref: 'Institutions',
      required: true,
    },
  },
  { timestamps: true }
);

export const Enrollment = mongoose.model('Enrollment', EnrollmentSchema);
