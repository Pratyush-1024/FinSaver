const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const balanceSchema = new Schema({
  month: {
    type: String,
    required: true,
  },
  balance: {
    type: Number,
    required: true,
  },
  amountSpent: {
    type: Number,
    required: true,
  },
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
}, {
  timestamps: true,
});

balanceSchema.index({ month: 1, user: 1 }, { unique: true });

const Balance = mongoose.model('Balance', balanceSchema);

module.exports = Balance;
