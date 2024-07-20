import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const TeacherSchema = new Schema({
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
  modules: [{ type: Schema.Types.ObjectId, ref: 'Module' }],
});

export const Teacher = mongoose.model('Teacher', TeacherSchema);