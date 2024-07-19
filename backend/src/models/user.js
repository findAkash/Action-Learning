import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import { CONFIG } from '../../config/confg.js';
import jwt from 'jsonwebtoken';

const Schema = mongoose.Schema;

const UserSchema = new Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
      immutable: true,
    },
    secondaryEmail: {
      type: String,
      trim: true,
      required: false,
    },
    password: {
      type: String,
      required: true,
    },
    firstName: {
      type: String,
      required: true,
      trim: true,
    },
    lastName: {
      type: String,
      required: true,
      trim: true,
    },
    role: {
      type: String,
      required: true,
      default: 'student',
    },
    institution: {
      type: Schema.Types.ObjectId,
      ref: 'Institutions',
    },
    tokens: {
      token: {
        type: String,
        required: false,
      },
      refreshToken: {
        type: String,
        required: false,
      },
    },
  },
  { timestamps: true }
);

// hash password before saving
UserSchema.pre('save', function (next) {
  if (!this.isModified('password')) {
    return next();
  }
  // if (
  //   this.password.length < 5 &&
  //   !/\d/.test(this.password) &&
  //   !/[!@#$%^&*(),.?":{}|<>]/.test(this.password)
  // ) {
  //   return next(
  //     new Error(
  //       'Password must be at least 6 characters and contain at least one number and one special character'
  //     )
  //   );
  // }
  const salt = bcrypt.genSaltSync(CONFIG.SALT);
  this.password = bcrypt.hashSync(this.password, salt);
  next();
});

UserSchema.methods.comparePassword = function (password) {
  return bcrypt.compare(password, this.password);
};

UserSchema.methods.generateToken = function () {
  if (this.tokens.token) {
    return this.tokens.token;
  }
  const token = jwt.sign({ _id: this._id, superadmin: false }, CONFIG.SECRET);
  this.tokens.token = token;
  this.save();
  return token;
};

// hide attributes
UserSchema.methods.toJSON = function () {
  var obj = this.toObject();
  delete obj.password;
  delete obj.__v;
  return obj;
};

export const User = mongoose.model('User', UserSchema);
