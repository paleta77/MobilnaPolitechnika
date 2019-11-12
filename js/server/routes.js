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
        user.register(req.body.username, req.body.mail, req.body.password, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    // get all user grades
    app.get('/grades', auth.restrict, (req, res) => {
        req.session.user.getGrades((err, grades) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", grades: grades });
        });
    });

    // add new grade to user
    app.put('/grades', auth.restrict, (req, res) => {
        req.session.user.addGrade(req.body.subject, req.body.value, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    //update grade
    app.post('/grades', auth.restrict, (req, res) => {
        req.session.user.updateGrade(req.body.subject, req.body.value, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    // delete grade
    app.delete('/grades', auth.restrict, (req, res) => {
        req.session.user.deleteGrade(req.body.subject, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    // get user group with they timetable
    app.get('/group', auth.restrict, (req, res) => {
        req.session.user.getGroup((err, _group) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", group: _group });
        });
    });
}