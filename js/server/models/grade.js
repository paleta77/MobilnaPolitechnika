const mongoose = require('mongoose');

const grade = mongoose.model('Grade', { semester: Number, value: Number, subject: String, ects: Number, user: String });

module.exports = grade;