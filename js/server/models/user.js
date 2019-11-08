const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const sendgrid = require('@sendgrid/mail');
const group = require('./group.js');
const auth = require('../auth.js');

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
        return;
    }
}

userSchema.loadClass(UserClass);

const user = mongoose.model('User', userSchema);

module.exports = user;