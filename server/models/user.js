const mongoose = require('mongoose');
const bcryptjs = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
    index: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: 'Please enter a valid email address!',
    },
  },
  password: {
    required: true,
    type: String,
  },
  
  address: {
    type: String,
    default: '',
  },
  type: {
    type: String,
    default: 'user',
  },

  transactions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Transaction' }],
});


const User = mongoose.model("User", userSchema);
module.exports = User;
