const mongoose = require('mongoose');

const grade = mongoose.model('Grade', { value: Number, subject: String, ects: Number, user: String });

module.exports = grade;