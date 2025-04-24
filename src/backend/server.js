const express = require('express');
const cors = require('cors');
const path = require('path');
const mongoose = require('mongoose');
require('dotenv').config();

// Import the Thread model
const Thread = require('./models/Thread');

const app = express();
const port = process.env.PORT || 5000;

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI)
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('MongoDB connection error:', err));

// Middleware
app.use(cors());
app.use(express.json());

// Routes - Updated to use MongoDB and async/await
app.get('/api/threads', async (req, res) => {
  try {
    const threads = await Thread.find().sort({ createdAt: -1 });
    res.json(threads);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.post('/api/threads', async (req, res) => {
  try {
    const { title, content, tags } = req.body;
    const newThread = new Thread({
      title,
      content,
      author: 'User', // In production, get from auth
      votes: 0,
      tags: tags || [] 
    });
    
    const savedThread = await newThread.save();
    res.status(201).json(savedThread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

app.post('/api/threads/:threadId/comments', async (req, res) => {
  try {
    const { threadId } = req.params;
    const { content } = req.body;
    
    const thread = await Thread.findById(threadId);
    if (!thread) {
      return res.status(404).json({ error: 'Thread not found' });
    }

    thread.comments.push({
      content,
      author: 'User', // In production, get from auth
    });

    const updatedThread = await thread.save();
    res.status(201).json(updatedThread.comments[updatedThread.comments.length - 1]);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

app.post('/api/threads/:threadId/vote', async (req, res) => {
  try {
    const { threadId } = req.params;
    const { direction } = req.body;
    
    const thread = await Thread.findById(threadId);
    if (!thread) {
      return res.status(404).json({ error: 'Thread not found' });
    }

    thread.votes += direction === 'up' ? 1 : -1;
    await thread.save();
    
    res.json({ votes: thread.votes });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Add these new routes for more functionality
app.get('/api/threads/:threadId', async (req, res) => {
  try {
    const thread = await Thread.findById(req.params.threadId);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    res.json(thread);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.put('/api/threads/:threadId', async (req, res) => {
  try {
    const thread = await Thread.findByIdAndUpdate(
      req.params.threadId,
      req.body,
      { new: true }
    );
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    res.json(thread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

app.delete('/api/threads/:threadId', async (req, res) => {
  try {
    const thread = await Thread.findByIdAndDelete(req.params.threadId);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    res.json({ message: 'Thread deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Serve static files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '../frontend/build')));
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/build/index.html'));
  });
}

app.listen(port, () => {
  console.log(`Server is running on port: ${port}`);
});