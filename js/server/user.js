const mongoose = require('mongoose');

const user = mongoose.model('User', { name: String, password: String });

module.exports = user;