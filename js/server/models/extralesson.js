const mongoose = require('mongoose');

const extralesson = mongoose.model('extralesson', {subject: String, user:String});

module.exports = extralesson;