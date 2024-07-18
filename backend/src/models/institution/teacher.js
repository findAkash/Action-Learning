import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const TeacherSchema = new Schema({
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
  courses: [{ type: Schema.Types.ObjectId, ref: 'Course' }],
});

export const Teacher = mongoose.model('Teacher', TeacherSchema);
