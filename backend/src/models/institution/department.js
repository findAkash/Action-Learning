import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const DepartmentSchema = new Schema({
  name: { type: String, required: true },
  institution: {
    type: Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
  courses: [{ type: Schema.Types.ObjectId, ref: 'Course' }],
});

export const Department = mongoose.model('Department', DepartmentSchema);
