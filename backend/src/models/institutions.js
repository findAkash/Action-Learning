import mongoose from 'mongoose';
const Schema = mongoose.Schema;
import { User } from './users.js';

const Institutions = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      unique: true,
    },
    address: {
      type: String,
      required: true,
      trim: true,
    },
    phone: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
    },
    website: {
      type: String,
      required: false,
      trim: true,
    },
  },
  { timestamps: true }
);

Institutions.pre('save', async function (next) {
  try {
    const user = new User({
      email: this.email,
      password: 'admin',
      firstName: 'Admin',
      lastName: this.name,
      role: 'admin',
      institution: this._id,
    });

    await user.save();

    next();
  } catch (error) {
    next(error);
  }
});

// hide attributes
Institutions.methods.toJSON = function () {
  var obj = this.toObject();
  delete obj.__v;
  delete obj.updatedAt;
  return obj;
};

export const Institution = mongoose.model('Institutions', Institutions);
