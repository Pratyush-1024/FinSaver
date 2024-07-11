const express = require('express');
const docsRouter = express.Router();
const multer = require('multer');
const path = require('path');
const crypto = require('crypto');
const auth = require('../middlewares/auth');
const Document = require('../models/doc');

// Multer configuration for file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads/');
  },
  filename: function (req, file, cb) {
    crypto.randomBytes(16, (err, hash) => {
      if (err) cb(err);
      const fileName = hash.toString('hex') + path.extname(file.originalname);
      cb(null, fileName);
    });
  },
});

const upload = multer({ storage: storage });

// POST /api/docs/upload - Upload a document
docsRouter.post('/api/docs/upload', auth, upload.single('document'), async (req, res) => {
  try {
    const { filename } = req.file;
    const user = req.user; 

    const newDocument = new Document({
      user,
      fileName: filename,
      filePath: `/server/uploads/${filename}`, 
      fileSize: req.file.size,
    });

    const savedDocument = await newDocument.save();
    res.json(savedDocument);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/docs - Get all documents for a user
docsRouter.get('/api/docs/getAll', auth, async (req, res) => {
  try {
    const documents = await Document.find({ user: req.user });
    const documentsWithUrls = documents.map(doc => ({
      ...doc.toObject(),
      fileUrl: `${req.protocol}://${req.get('host')}${doc.filePath}`
    }));
    res.json(documentsWithUrls);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/docs/:filename - Serve documents (images)
docsRouter.get('/api/docs/files/:filename', auth, async (req, res) => {
  try {
    const filePath = path.join(__dirname, '../uploads', req.params.filename);
    res.sendFile(filePath);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});



// PUT /api/docs/:id - Update a document by ID
docsRouter.put('/api/docs/update/:id', auth, async (req, res) => {
  try {
    const { fileName, filePath, fileSize } = req.body;
    const documentFields = {};
    if (fileName) documentFields.fileName = fileName;
    if (filePath) documentFields.filePath = filePath;
    if (fileSize) documentFields.fileSize = fileSize;

    let document = await Document.findById(req.params.id);
    if (!document) {
      return res.status(404).json({ msg: 'Document not found' });
    }

    document = await Document.findByIdAndUpdate(
      req.params.id,
      { $set: documentFields },
      { new: true }
    );

    res.json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE /api/docs/:id - Delete a document by ID
docsRouter.delete('/api/docs/delete/:id', auth, async (req, res) => {
  try {
    const deletedDocument = await Document.findByIdAndDelete(req.params.id);
    if (!deletedDocument) {
      return res.status(404).json({ msg: 'Document not found' });
    }
    res.json({ msg: 'Document deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = docsRouter;
