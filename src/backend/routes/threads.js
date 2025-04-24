const express = require('express');
const router = express.Router();
const Thread = require('../models/Thread');

// Get all threads
router.get('/', async (req, res) => {
  try {
    const threads = await Thread.find().sort({ isPinned: -1, createdAt: -1 });
    res.json(threads);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get single thread
router.get('/:id', async (req, res) => {
  try {
    const thread = await Thread.findById(req.params.id);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    res.json(thread);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create thread
router.post('/', async (req, res) => {
  const thread = new Thread({
    title: req.body.title,
    content: req.body.content,
    author: req.body.author,
    tags: req.body.tags
  });

  try {
    const newThread = await thread.save();
    res.status(201).json(newThread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update thread
router.patch('/:id', async (req, res) => {
  try {
    const thread = await Thread.findById(req.params.id);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    
    if (req.body.title) thread.title = req.body.title;
    if (req.body.content) thread.content = req.body.content;
    if (req.body.status) thread.status = req.body.status;
    if (req.body.isPinned !== undefined) thread.isPinned = req.body.isPinned;
    if (req.body.votes) thread.votes = req.body.votes;
    
    const updatedThread = await thread.save();
    res.json(updatedThread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Add comment
router.post('/:id/comments', async (req, res) => {
  try {
    const thread = await Thread.findById(req.params.id);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    
    thread.comments.push({
      author: req.body.author,
      content: req.body.content
    });
    
    const updatedThread = await thread.save();
    res.status(201).json(updatedThread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete thread
router.delete('/:id', async (req, res) => {
  try {
    const thread = await Thread.findById(req.params.id);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    
    await thread.remove();
    res.json({ message: 'Thread deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;