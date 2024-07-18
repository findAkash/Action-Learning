import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const BatchSchema = new Schema({
  batchName: { type: String, required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  institutionId: {
    type: Schema.Types.ObjectId,
    ref: 'Institutions',
    required: true,
  },
});
export const Batch = mongoose.model('Batch', BatchSchema);
