const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const sendgrid = require('@sendgrid/mail');
const group = require('./group.js');
const auth = require('../auth.js');
const grade = require('./grade.js');
const extralesson = require('./extralesson.js');

const userSchema = new mongoose.Schema({
    name: String,
    mail: String,
    password: String,
    group: { type: mongoose.Schema.Types.ObjectId, ref: 'Group' }
});

class UserClass {
    static login(username, password, cb) {
        this.findOne({ 'name': username }, (err, _user) => {
            if (err || !_user) return cb("Error occurs!");

            bcrypt.compare(password, _user.password, (herr, _res) => {
                if (_res) {
                    // Passwords match
                    let id = auth.genToken(); // generate auth token
                    auth.sessions[id] = _user;
                    cb(null, { token: id });
                } else {
                    cb("Wrong password!");
                }
            });
        });
    }

    static register(username, mail, password, cb) {
        if (!username || !mail || !password) {
            return cb("Field cannot be empty!");
        }
        this.findOne(
            { $or: [{ 'name': username }, { 'mail': mail }] },
            'name',
            (err, name) => {
                if (err) return cb(err);
                if (!name) {
                    bcrypt.hash(password, 10, function (err, hash) {
                        if (err) cb(err);
                        user.create({ name: username, mail: mail, password: hash }, function (err, _user) {
                            if (err) cb(err);

                            sendgrid.send({
                                to: mail,
                                from: 'noreply@mojmegatestkolejny.azurewebsites.net',
                                subject: 'Welcome to Mobilna Politechnika',
                                text: `Welcome ${username} :)`
                            });

                            cb(null, true);
                        });
                    });
                }
                else {
                    cb("Username or email already in use!");
                }
            });
    }

    getGroup(cb) {
        group.findOne({ '_id': this.group }, (err, _group) => {
            if (err) return cb(err);
            cb(null, _group);
        });
    }

    setGroup(_group, cb) {
        this.group = _group._id;
        this.save(function (err) {
            if (err) return cb(err);
            cb(null, true);
          });
    }

    getGrades(cb) {
        grade.find({ 'user': this.name }, 'value subject', (err, grades) => {
            if (err) cb(err);
            cb(null, grades);
        });
    }

    addGrade(subject, value, cb) {
        if (!subject || !value) {
            return cb("Fields cannot be empty!");
        }
        if (value > 5 || value < 2) {
            return cb("Value outside 2 and 5!");
        }
        grade.create({ 'user': this.name, 'subject': subject, 'value': value }, function (err) {
            if (err) cb(err);
            cb(null, true);
        });
    }

    updateGrade(subject, value, cb) {
        if (!subject || !value) {
            return cb("Fields cannot be empty!");
        }
        if (value > 5 || value < 2) {
            return cb("Value outside 2 and 5!");
        }
        grade.updateOne({ 'user': this.name, 'subject': subject }, { $set: { 'value': value } }, function (err) {
            if (err) cb(err);
            cb(null, true);
        });
    }

    deleteGrade(subject, cb) {
        grade.deleteOne({ 'user': this.name, 'subject': subject }, function (err) {
            if (err) cb(err);
            cb(null, true);
        });
    }

    deleteExtraLesson(subject, cb){
        extralesson.deleteOne({'subject': subject, 'user': this.name}, function (err) {
            if (err) cb(err);
            cb(null, true);
        });
    }

    addExtraLesson(subject, cb) {
        extralesson.create({'subject': subject, 'user': this.name}, function (err) {
            if (err) cb(err);
            cb(null, true);
        });
    }

    getExtraLessons(cb) {
        extralesson.find({'user': this.name}, (err, _extraLessons) => {
            if(err) return cb(err);
            cb(null, _extraLessons);
        });
    }
}

userSchema.loadClass(UserClass);

const user = mongoose.model('User', userSchema);

module.exports = user;

// remove me after testing
user.findOne({ 'name': 'admin' }, (err, _user) => {
    if (err || !_user) return;
    setTimeout(()=>auth.sessions['123'] = _user, 1000);
});