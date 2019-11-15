const mongoose = require('mongoose');

const tableSchema = mongoose.Schema({
    group: { type: mongoose.Schema.Types.ObjectId, ref: 'Group' },
    day: String,
    hour: Number,
    length: Number,
    subject: String,
    type: String,
    classroom: String,
    lecturer: String
});

tableSchema.index({ day: 'text', subject: 'text', classroom: 'text', type:'text', lecturer: 'text' });

const table = mongoose.model('Timetable', tableSchema);

module.exports = table;