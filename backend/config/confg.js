import dotenv from 'dotenv';
dotenv.config();

export const CONFIG = {
  database: {
    URL:
      process.env.DATABASE_URL ||
      'mongodb+srv://findakash:text1234567890@cluster0.grpw3tv.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0',
  },
  server: {
    PORT: process.env.PORT || 8000,
  },
  SECRET: '123@#$!@!#1234' || env.SECRET,
  SALT: 10 || (env.SALT && parseInt(env.SALT, 10)),
};
