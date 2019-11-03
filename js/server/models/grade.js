const mongoose = require('mongoose');

const grade = mongoose.model('Grade', { value: Number, subject: String, user: String });

function getAll(user, res) {
    grade.find({ 'user': user }, 'value subject user', (err, grades) => {
        if (err) return handleError(err);
        res.json(grades);
    });
}

function add(user, subject, value, res) {
    if (!user || !subject || !value) {
        res.json({ msg: "Field cannot be empty!" });
        return;
    }
    if (value > 5 || value < 2) {
        res.json({ msg: "Value outside 2 and 5!" });
        return;
    }
    grade.create({ 'user': user, 'subject': subject, 'value': value }, function (err) {
        if (err) return handleError(err);
        res.json({ msg: "OK" });
    });
}

function del(user, subject, res) {
    grade.deleteOne({ 'user': user, 'subject': subject }, function (err) {
        if (err) return handleError(err);
        res.json({ msg: "OK" });
    });
}

module.exports = {
    'model': grade,
    'getAll': getAll,
    'add': add,
    'del': del
};