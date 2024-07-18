import e from 'express';
import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const Roles = new Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    unique: true,
  },
  //   permissions: [
  //     {
  //       type: Schema.Types.ObjectId,
  //       ref: 'Permission',
  //     },
  //   ],
  timestamps: true,
});

// create permissions by default
// Roles.pre('save', function (next) {
//   if (this.isNew) {
//     const permissions = ['create', 'read', 'update', 'delete'];
//     this.permissions = permissions;
//   }
//   next();
// });

export default mongoose.model('Roles', Roles);
