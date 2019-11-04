const mongoose = require('mongoose');

const grade = mongoose.model('Grade', { value: Number, subject: String, user: String });

module.exports = grade;