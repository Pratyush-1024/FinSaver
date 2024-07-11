const express = require("express");
const Notification = require("../models/noti");
const auth = require("../middlewares/auth");

const notificationRouter = express.Router();

// POST /api/notification/create - Create a new notification
notificationRouter.post('/api/notification/create', auth, async (req, res) => {
  try {
    const { title, body } = req.body;
    const notification = new Notification({
      title,
      body,
      user: req.user,  
    });
    const savedNotification = await notification.save();
    res.json(savedNotification);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/notification/all - Get all notifications for a user
notificationRouter.get('/api/notification/all', auth, async (req, res) => {
  try {
    const notifications = await Notification.find({ user: req.user });
    res.json(notifications);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// DELETE /api/notification/:_id - Delete a notification by ID
notificationRouter.delete('/api/notification/:_id', auth, async (req, res) => {
  try {
    const deletedNotification = await Notification.findByIdAndDelete(req.params._id);
    if (!deletedNotification) {
      return res.status(404).json({ msg: 'Notification not found' });
    }
    res.json({ msg: 'Notification deleted' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = notificationRouter;
