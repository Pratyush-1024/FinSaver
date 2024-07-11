const express = require('express');
const Transaction = require('../models/transact');
const Balance = require('../models/balance');
const { v4: uuidv4 } = require('uuid');
const auth = require('../middlewares/auth');

const transactionRouter = express.Router();

const months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];


transactionRouter.post('/api/transactions/create', auth, async (req, res) => {
  try {
    const { recipient, amount, type, imageUrl, month } = req.body;  
    const userId = req.user;

    const transaction = new Transaction({
      userId,
      recipient,
      amount,
      type,
      imageUrl,
      transactionId: uuidv4(),
      month 
    });

    await transaction.save();

    let balanceRecord = await Balance.findOne({ user: userId, month });

    if (!balanceRecord) {
      balanceRecord = new Balance({
        month,
        balance: 0,
        amountSpent: 0,
        user: userId,
      });
    }

    if (type === 'income') {
      balanceRecord.balance = parseFloat(balanceRecord.balance) + parseFloat(amount);
    } else {
      balanceRecord.amountSpent = parseFloat(balanceRecord.amountSpent) + parseFloat(amount);
    }

    await balanceRecord.save();
    res.json(transaction);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

transactionRouter.get('/api/transactions', auth, async (req, res) => {
  try {
    const userId = req.user;
    const transactions = await Transaction.find({ userId }).sort({ date: -1 });
    res.json(transactions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

transactionRouter.get('/api/transactions/recent', auth, async (req, res) => {
  try {
    const userId = req.user;
    const transactions = await Transaction.find({ userId })
      .sort({ date: -1 })
      .limit(4);
    res.json(transactions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = transactionRouter;
