const mongoose = require('mongoose');

const threadSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  author: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
  votes: { type: Number, default: 0 },
  status: { type: String, default: 'open' },
  isPinned: { type: Boolean, default: false },
  tags: [{ 
    id: Number,
    name: String,
    color: String
  }],
  comments: [{
    author: String,
    content: String,
    timestamp: { type: Date, default: Date.now },
    editedAt: Date
  }]
}, { timestamps: true });

module.exports = mongoose.model('Thread', threadSchema);