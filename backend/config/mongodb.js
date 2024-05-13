const mongoose = require('mongoose');
import config from '../config/confg';

module.exports = () => {
  // mongoose to use Promises
  mongoose.Promise = global.Promise;
  // connect to database
  return mongoose.connect(config.database.url, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useUnifiedTopology: true,
    useFindAndModify: false,
    poolSize: 15,
  });
};
