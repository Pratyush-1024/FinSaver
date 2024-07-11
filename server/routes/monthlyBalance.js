const express = require('express');
const Balance = require('../models/balance');
const auth = require('../middlewares/auth');

const balanceRouter = express.Router();

balanceRouter.get('/api/balance/all', auth, async (req, res) => {
  try {
    const user = req.user;
    const allBalances = await Balance.find({ user });
    res.json(allBalances);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/balance/update - Update the monthly balance
balanceRouter.post('/api/balance/update', auth, async (req, res) => {
  try {
    const { month, balance, amountSpent } = req.body;

    let balanceRecord = await Balance.findOne({ user: req.user, month  });

    if (!balanceRecord) {
      balanceRecord = new Balance({
        month,
        balance,
        amountSpent,
        user: req.user, 
      });
    } else {
      balanceRecord.balance = balance;
      balanceRecord.amountSpent = amountSpent;
    }

    const savedBalance = await balanceRecord.save();
    res.json(savedBalance);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


// GET /api/balance/:month - Get the balance for a specific month
balanceRouter.get('/api/balance/:month', auth, async (req, res) => {
  try {
    const { month } = req.params;

    const balanceRecord = await Balance.findOne({ user: req.user, month });

  
    if (!balanceRecord) {
      return res.json({ balance: 0.0, amountSpent: 0.0 });
    }
    res.json(balanceRecord);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = balanceRouter;
