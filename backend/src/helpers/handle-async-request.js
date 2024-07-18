import mongoose from 'mongoose';

export class APIError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

export const handleAsyncRequest = (handler) => async (req, res, next) => {
  try {
    const result = await handler(req, res, next);
    if (!res.headersSent) {
      res.json(result);
    }
  } catch (e) {
    console.error(e);

    if (e instanceof APIError) {
      return res.status(e.status).json({ success: false, message: e.message });
    } else if (e instanceof mongoose.Error) {
      return res
        .status(400)
        .json({ success: false, message: 'Database error: ' + e.message });
    } else if (e instanceof SyntaxError) {
      return res
        .status(400)
        .json({ success: false, message: 'Syntax error: ' + e.message });
    } else if (e instanceof TypeError) {
      return res
        .status(400)
        .json({ success: false, message: 'Type error: ' + e.message });
    } else if (e instanceof RangeError) {
      return res
        .status(400)
        .json({ success: false, message: 'Range error: ' + e.message });
    } else if (e instanceof ReferenceError) {
      return res
        .status(400)
        .json({ success: false, message: 'Reference error: ' + e.message });
    } else if (e instanceof URIError) {
      return res
        .status(400)
        .json({ success: false, message: 'URI error: ' + e.message });
    } else {
      return res
        .status(500)
        .json({ success: false, message: 'Internal Server Error' });
    }
  }
};
