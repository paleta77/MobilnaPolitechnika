const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const user = require('./models/user.js');
const grade = require('./models/grade.js');
const group = require('./models/group.js');
const auth = require('./auth.js');

const config = require('./config.js');
const sendgrid = require('@sendgrid/mail');
sendgrid.setApiKey(config.sendgridkey);
delete config;

exports = module.exports = function (app) {

    // check if user is logged in
    app.get('/logged', (req, res) => {
        if (req.session.user) {
            res.json({ msg: "YES" });
        }
        else {
            res.json({ msg: "NO" });
        }
    });

    // remove user session
    app.get('/logout', auth.restrict, (req, res) => {
        delete auth.sessions[req.session.id];
        req.session = {};
        res.json({ msg: "OK" });
    });

    // login using username nad password
    app.post('/login', (req, res) => {
        user.findOne({ 'name': req.body.username }, 'name password', (err, _user) => {
            if (err || !_user) return res.json({ msg: "Error occurs!" });

            bcrypt.compare(req.body.password, _user.password, (herr, _res) => {
                if (_res) {
                    // Passwords match
                    let id = auth.genToken(); // generate auth token
                    auth.sessions[id] = _user;
                    res.json({ msg: "OK", token: id });
                } else {
                    return res.json({ msg: "Wrong password!" });
                }
            });
        });
    });

    // register new user
    app.post('/register', (req, res) => {
        if (!req.body.username || !req.body.mail || !req.body.password) {
            return res.json({ msg: "Field cannot be empty!" });
        }
        user.findOne(
            { $or: [{ 'name': req.body.username }, { 'mail': req.body.mail }] },
            'name', 
            (err, _user) => {
                if (err) return res.json({ msg: err });
                if (!_user) {
                    bcrypt.hash(req.body.password, 10, function (err, hash) {
                        if (err) return res.json({ msg: err });
                        user.create({ name: req.body.username, mail: req.body.mail, password: hash }, function (err, _user2) {
                            if (err) return res.json({ msg: err });

                            const msg = {
                                to: req.body.mail,
                                from: 'noreply@mojmegatestkolejny.azurewebsites.net',
                                subject: 'Welcome to Mobilna Politechnika',
                                text: `Welcome ${req.body.username} :)`
                              };
                              sendgrid.send(msg);

                            res.json({ msg: "OK" });
                        });
                    });
                }
                else {
                    res.json({ msg: "Username or email already in use!" });
                }
            });
    });

    // get all user grades
    app.get('/grades/:user', auth.restrict, (req, res) => {
        grade.find({ 'user': req.params['user'] }, 'value subject user', (err, grades) => {
            if (err) return handleError(err);
            res.json(grades);
        });
    });

    // add new grade to user
    app.put('/grades', auth.restrict, (req, res) => {
        let [user, subject, value] = [req.body.user, req.body.subject, req.body.value];
        if (!user || !subject || !value) {
            return res.json({ msg: "Field cannot be empty!" });
        }
        if (value > 5 || value < 2) {
            return res.json({ msg: "Value outside 2 and 5!" });
        }
        grade.create({ 'user': user, 'subject': subject, 'value': value }, function (err) {
            if (err) return handleError(err);
            res.json({ msg: "OK" });
        });
    });

    //update grade
    app.post('/grades', auth.restrict, (req, res) => {
        let [user, subject, value] = [req.body.user, req.body.subject, req.body.value];
        if (!user || !subject || !value) {
            return res.json({ msg: "Field cannot be empty!" });
        }
        if (value > 5 || value < 2) {
            return res.json({ msg: "Value outside 2 and 5!" });
        }
        grade.updateOne({ 'user': user, 'subject': subject }, { $set: { 'value': value } }, function (err) {
            if (err) return handleError(err);
            res.json({ msg: "OK" });
        });
    });

    // delete grade
    app.delete('/grades', auth.restrict, (req, res) => {
        grade.deleteOne({ 'user': req.body.user, 'subject': req.body.subject }, function (err) {
            if (err) return handleError(err);
            res.json({ msg: "OK" });
        });
    });

    // get user group with they timetable
    app.get('/group/:user', auth.restrict, (req, res) => {
        user.findOne({ 'name': req.params['user'] }, 'group', (err, _user) => {
            if (err) return res.json({ msg: err });
            if (_user) {
                group.findOne({ '_id': _user.group }, (err, _group) => {
                    if (err) return res.json({ msg: err });
                    res.json({ msg: "OK", group: _group });
                });
                return;
            }
            res.json({ msg: "No user" });
        });
    });
}