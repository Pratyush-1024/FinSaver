const express = require("express");
const UserBankDetails = require("../models/userBD");
const auth = require("../middlewares/auth");

const userBankDetailsRouter = express.Router();

// POST /api/userBankDetails/create - Create a new user bank detail
userBankDetailsRouter.post('/api/userBankDetails/create', auth, async (req, res) => {
  try {
    const { accountName, accountNumber, phoneNumber } = req.body;
    const userBankDetail = new UserBankDetails({
      accountName,
      accountNumber,
      phoneNumber,
      user: req.user,
    });
    const savedUserBankDetail = await userBankDetail.save();
    res.json(savedUserBankDetail);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/userBankDetails - Get a single bank detail for a user
userBankDetailsRouter.get('/api/userBankDetails/get/:_id', auth, async (req, res) => {
    try {
      const userBankDetail = await UserBankDetails.findOne({ user: req.user });
      if (!userBankDetail) {
        return res.status(404).json({ msg: 'User bank detail not found' });
      }
      res.json(userBankDetail);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  // PUT /api/userBankDetails/update/:_id - Update user bank details
userBankDetailsRouter.put('/api/userBankDetails/update/:_id', auth, async (req, res) => {
  try {
    const { accountName, accountNumber, phoneNumber } = req.body;
    const updatedUserBankDetail = await UserBankDetails.findOneAndUpdate(
      { user: req.params._id },
      { accountName, accountNumber, phoneNumber },
      { new: true }
    );

    if (!updatedUserBankDetail) {
      return res.status(404).json({ msg: 'User bank detail not found' });
    }

    res.json(updatedUserBankDetail);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/userBankDetails/:_id - Delete a bank detail by ID
userBankDetailsRouter.delete('/api/userBankDetails/delete/:_id', auth, async (req, res) => {
  try {
    const deletedUserBankDetail = await UserBankDetails.findByIdAndDelete(req.params._id);
    if (!deletedUserBankDetail) {
      return res.status(404).json({ msg: 'User bank detail not found' });
    }
    res.json({ msg: 'User bank detail deleted' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userBankDetailsRouter;
