const mongoose = require('mongoose');

const grade = mongoose.model('Grade', { value: Number, subject: String, user: String });

function getAll(user, res) {
    grade.find({ 'user': user }, 'value subject user', (err, grades) => {
        if (err) return handleError(err);
        res.json(grades);
    });
}

function add() {

}

function del(user, subject) {
    grade.deleteOne({ 'user': user, 'subject': subject }, function (err) {
        if (err) return handleError(err);
      });
}

module.exports = {
   'model': grade,
   'getAll': getAll,
   'add': add,
   'del': del
};