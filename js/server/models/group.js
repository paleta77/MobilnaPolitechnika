const mongoose = require('mongoose');
const timetable = require('./timetable.js');

const groupSchema = new mongoose.Schema({ field: String, semester: Number, mode: String, timetable: [timetable.schema] });

groupSchema.index({ field: 'text', mode: 'text' });

const group = mongoose.model('Group', groupSchema);

module.exports = group;