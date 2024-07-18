import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const StudentSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  institutionId: {
    type: Schema.Types.ObjectId,
    ref: 'Institution',
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