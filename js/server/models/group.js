const mongoose = require('mongoose');
const timetable = require('./timetable.js');

const group = mongoose.model('Group', { field: String, semester: Number, mode: String, timetable: [timetable.schema]});

module.exports = group;