import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import { CONFIG } from '../../config/confg.js';
import { time, timeStamp } from 'console';
import jwt from 'jsonwebtoken';

const superAdminSchema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    tokens: {
      token: {
        type: String,
        required: true,
      },
      refeshToken: {
        type: String,
        required: false,
      },
    },
  },
  { timestamps: true }
);

superAdminSchema.pre('save', async function (next) {
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(CONFIG.SALT);
  this.password = bcrypt.hashSync(this.password, salt);
});

superAdminSchema.methods.comparePassword = async function (password) {
  return bcrypt.compare(password, this.password);
};

superAdminSchema.methods.generateToken = function () {
  if (this.tokens.token) {
    return this.tokens.token;
  }
  const token = jwt.sign({ _id: this._id, superadmin: true }, CONFIG.SECRET);
  this.tokens.token = token;
  this.save();
  return token;
};

superAdminSchema.methods.removeToken = function (token) {
  this.tokens = this.tokens.filter((t) => t.token !== token);
  this.save();
};

// remove password from the response
superAdminSchema.methods.toJSON = function () {
  const superAdmin = this.toObject();
  delete superAdmin.password;
  delete superAdmin.__v;
  return superAdmin;
};

export const SuperAdmin = mongoose.model('SuperAdmin', superAdminSchema);
