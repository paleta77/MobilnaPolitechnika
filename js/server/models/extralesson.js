const mongoose = require('mongoose');

const extralesson = mongoose.model('extralesson', {
    day: String,
    hour: Number,
    length: Number,
    subject: String,
    type: String,
    classroom: String,
    lecturer: String,
    user: String
});

module.exports = extralesson;