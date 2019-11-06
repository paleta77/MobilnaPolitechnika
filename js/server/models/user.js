const mongoose = require('mongoose');
const group = require('./group.js');

const user = mongoose.model('User', {
    name: String,
    mail: String,
    password: String,
    group: { type: mongoose.Schema.Types.ObjectId, ref: 'Group' }
});

module.exports = user;