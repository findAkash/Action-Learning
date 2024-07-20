import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const StudentSchema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  institution: {
    type: Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
  enrollments: [{ type: Schema.Types.ObjectId, ref: 'Enrollment' }],
  batch: {
    type: Schema.Types.ObjectId,
    ref: 'Batch',
    required: true,
  },
});

export const Student = mongoose.model('Student', StudentSchema);
