export class APIError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

export const handleAsyncRequest = (handler) => async (req, res) => {
  try {
    const result = await handler(req, res);
    if (!res.headersSent) {
      res.send(result);
    }
  } catch (e) {
    console.log(e);
    if (e instanceof APIError) {
      return res.status(e.status).send({ success: false, message: e.message });
    } else if (e instanceof mongoose.Error) {
      return res.status(400).send({ success: false, message: e.message });
    } else if (e instanceof SyntaxError) {
      return res.status(400).send({ success: false, message: e.message });
    } else if (e instanceof TypeError) {
      return res.status(400).send({ success: false, message: e.message });
    } else if (e instanceof RangeError) {
      return res.status(400).send({ success: false, message: e.message });
    } else if (e instanceof ReferenceError) {
      return res.status(400).send({ success: false, message: e.message });
    } else if (e instanceof URIError) {
      return res.status(400).send({ success: false, message: e.message });
    } else {
      return res
        .status(500)
        .send({ success: false, message: 'Internal Server Error' });
    }
  }
};

// module.exports = {
//   APIError,
//   handleAsyncRequest,
// };
