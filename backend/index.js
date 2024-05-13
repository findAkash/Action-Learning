import mongoose from 'mongoose';
import express from 'express';
import cors from 'cors';
import { API } from './src/api/api.js';
import { CONFIG } from './config/confg.js';

(async () => {
  // Connect to the MongoDB database
  await mongoose.connect(CONFIG.database.URL);
  const db = mongoose.connection;
  db.on('error', console.error.bind(console, 'MongoDB connection error:'));
  db.once('open', () => {
    console.log('Connected to the database');
  });

  const app = express();
  app.use(cors());
  app.use(express.json());

  app.get('/', (req, res) => {
    res.send('API for the application is running!');
  });

  app.use('/api/v1', API.instance());

  app.listen(CONFIG.server.PORT, () => {
    console.log(`Server running on port ${CONFIG.server.PORT}`);
  });
})();
