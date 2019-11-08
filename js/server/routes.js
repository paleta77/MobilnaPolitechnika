const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const user = require('./models/user.js');
const grade = require('./models/grade.js');
const group = require('./models/group.js');
const auth = require('./auth.js');

exports = module.exports = function (app) {

    // check if user is logged in
    app.get('/logged', (req, res) => {
        if (req.session.user)
            res.json({ msg: "YES" });
        else
            res.json({ msg: "NO" });
    });

    // remove user session
    app.get('/logout', auth.restrict, (req, res) => {
        delete auth.sessions[req.session.id];
        req.session = {};
        res.json({ msg: "OK" });
    });

    // login using username nad password
    app.post('/login', (req, res) => {
        user.login(req.body.username, req.body.password, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", token: _res.token });
        })
    });

    // register new user
    app.post('/register', (req, res) => {
        if (!req.body.username || !req.body.mail || !req.body.password) {
            return res.json({ msg: "Field cannot be empty!" });
        }

        user.register(req.body.username, req.body.mail, req.body.password, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
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
        req.session.user.getGroup((err, _group) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", group: _group });
        });
    });
}