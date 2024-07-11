const mongoose = require('mongoose');

const UserMoreDetailsSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  memberSince: {
    type: Date,
    required: true,
  },
  bio: {
    type: String,
    required: true,
  },
}, { timestamps: true });

module.exports = mongoose.model('UserMoreDetails', UserMoreDetailsSchema);
