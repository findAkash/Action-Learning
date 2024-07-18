import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const ModuleSchema = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  teachers: [
    { teacherId: Schema.Types.ObjectId, title: String, ref: 'Teacher' },
  ],
  credit: { type: Number, required: true },
  institutionId: {
    type: Schema.Types.ObjectId,
    ref: 'Institution',
    required: true,
  },
  batchId: { type: Schema.Types.ObjectId, ref: 'Batch', required: true },
  course: {
    type: Schema.Types.ObjectId,
    ref: 'Course',
    required: true,
  },
});

module.exports = mongoose.model('Module', ModuleSchema);
