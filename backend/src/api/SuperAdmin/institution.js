import { Router } from 'express';
import { Institution } from '../../models/institutions.js';
import {
  handleAsyncRequest,
  APIError,
} from '../../helpers/handle-async-request.js';

export class AdminInstitutionAPI {
  static instance() {
    const router = Router();

    router.post('/create', createInstitution);
    router.get('/get', getInstitutions);
    router.put('/update/:id', updateInstitution);
    router.delete('/delete/:id', deleteInstitution);
    return router;
  }
}

export const createInstitution = handleAsyncRequest(async (req, res) => {
  try {
    // Check if the institution already exists
    const isExist = await Institution.findOne({
      name: req.body.name,
      email: req.body.email,
    });

    if (isExist) {
      throw new APIError(400, 'Institution already exists');
    }

    // Create a new instance of the Institution model with the request body
    const institution = new Institution(req.body);

    // Save the new institution to the database
    await institution.save();

    // Respond with a success message and the created institution
    res.status(201).json({
      success: true,
      message: 'Institution created successfully',
      institution,
    });
  } catch (error) {
    // Handle errors
    console.error('Error creating institution:', error);
    res.status(error.status || 500).json({
      success: false,
      message: error.message || 'Error creating institution',
    });
  }
});

const getInstitutions = handleAsyncRequest(async (req) => {
  const institutions = await Institution.find();
  if (!institutions) {
    throw new APIError(404, 'Institutions not found');
  }
  return { success: true, institutions };
});

const updateInstitution = handleAsyncRequest(async (req) => {
  const Institution = await Institution.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true }
  );
  if (!Institution) {
    throw new APIError(404, 'Institution not found');
  }
  res.send({ success: true, Institution });
});

const deleteInstitution = handleAsyncRequest(async (req) => {
  const Institution = await Institution.findByIdAndDelete(req.params.id);
  if (!Institution) {
    throw new APIError(404, 'Institution not found');
  }
  res.send({ success: true, Institution });
});
