import { Router } from 'express';
import {
  handleAsyncRequest,
  APIError,
} from '../../../helpers/handle-async-request.js';
import { Batch } from '../../../models/institution/batch.js';

export class BatchAPI {
  static instance() {
    const router = Router();

    router.post('/create', createBatch);
    router.get('/list', getBatches);
    router.get('/:id', getBatchById);
    router.put('/update/:id', updateBatch);
    router.delete('/delete/:id', deleteBatch);

    return router;
  }
}

const createBatch = handleAsyncRequest(async (req, res) => {
  const { batchName, startDate, endDate } = req.body;
  const institutionId = req.user.institution;

  // Check if the batch already exists for the given name and institution
  const existingBatch = await Batch.findOne({ batchName, institutionId });
  if (existingBatch) {
    throw new APIError(400, 'Batch already exists for this institution');
  }

  const batch = new Batch({
    batchName,
    startDate,
    endDate,
    institutionId,
  });

  await batch.save();
  res.status(201).json({ success: true, batch });
});

const getBatches = handleAsyncRequest(async (req, res) => {
  const batches = await Batch.find().populate('institutionId');
  if (!batches) {
    throw new APIError(404, 'Batches not found');
  }
  res.json({ success: true, batches });
});

const getBatchById = handleAsyncRequest(async (req, res) => {
  const batch = await Batch.findById(req.params.id).populate('institutionId');
  if (!batch) {
    throw new APIError(404, 'Batch not found');
  }
  res.json({ success: true, batch });
});

const updateBatch = handleAsyncRequest(async (req, res) => {
  const batch = await Batch.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  }).populate('institutionId');
  if (!batch) {
    throw new APIError(404, 'Batch not found');
  }
  res.json({ success: true, batch });
});

const deleteBatch = handleAsyncRequest(async (req, res) => {
  const batch = await Batch.findByIdAndDelete(req.params.id);
  if (!batch) {
    throw new APIError(404, 'Batch not found');
  }
  res.json({ success: true, message: 'Batch deleted successfully' });
});
