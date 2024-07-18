import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const DepartmentSchema = new Schema({
  name: { type: String, required: true },
  institution_id: {
    type: Schema.Types.ObjectId,
    ref: 'Institution',
    required: true,
  },
  courses: [{ type: Schema.Types.ObjectId, ref: 'Course' }],
});

module.exports = mongoose.model('Department', DepartmentSchema);
