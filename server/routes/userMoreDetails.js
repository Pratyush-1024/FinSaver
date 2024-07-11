const express = require("express");
const UserMD = require("../models/userMD"); 
const auth = require("../middlewares/auth");

const userMoreDetailsRouter = express.Router();

// POST /api/more-details/create - Create a new user more detail
userMoreDetailsRouter.post('/api/more-details/create', auth, async (req, res) => {
  try {
    const { address, bio } = req.body;
    const userMoreDetail = new UserMD({
      user: req.user, 
      address,
      memberSince: new Date(),
      bio,
    });
    const savedUserMoreDetail = await userMoreDetail.save();
    res.status(201).json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// GET /api/more-details/get/:id - Get more details for a user
userMoreDetailsRouter.get('/api/more-details/get/:_id', auth, async (req, res) => {
  try {
    const userMoreDetail = await UserMD.findOne({ user: req.params._id }); 
    if (!userMoreDetail) {
      return res.status(404).json({ msg: 'User more details not found' });
    }
    res.json(userMoreDetail);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// PUT /api/more-details/update/:id - Update user more details by ID
userMoreDetailsRouter.patch('/api/more-details/update/:_id', auth, async (req, res) => {
  try {
    const { address, bio } = req.body;
    
    const updatedUserMoreDetail = await UserMD.findOneAndUpdate(
      { user: req.params._id }, 
      { address, bio }, 
      { new: true } 
    );
   
    if (!updatedUserMoreDetail) {
      return res.status(404).json({ msg: 'User more details not found' });
    }
    
    res.json(updatedUserMoreDetail);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// DELETE /api/more-details/delete/:id - Delete a more detail by ID
userMoreDetailsRouter.delete('/api/more-details/delete/:_id', auth, async (req, res) => {
  try {
    const deletedUserMoreDetail = await UserMD.findOneAndDelete({ user: req.params._id }); // Deleting by user ID
    if (!deletedUserMoreDetail) {
      return res.status(404).json({ msg: 'User more details not found' });
    }
    res.json({ msg: 'User more details deleted' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userMoreDetailsRouter;
