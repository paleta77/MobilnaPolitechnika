const mongoose = require('mongoose');
const timetable = require('./timetable.js');

const groupSchema = new mongoose.Schema({ field: String, semester: Number, mode: String });
groupSchema.index({ field: 'text', mode: 'text' });

class GroupClass {
    getTimeTable(cb) {
        timetable.find({ 'group': this._id }, '', (err, table) => {
            if (err) cb(err);
            cb(null, table);
        });
    }

    addSubject(day, hour, length, subject, type, classroom, lecturer, cb) {
        timetable.create(
            { group: this._id, day: day, hour: hour, length: length, subject: subject, type: type, classroom: classroom, lecturer: lecturer },
            (err, table) => {
                if (err) cb(err);
                cb(null, true);
            });
    }
}

groupSchema.loadClass(GroupClass);

const group = mongoose.model('Group', groupSchema);

module.exports = group;