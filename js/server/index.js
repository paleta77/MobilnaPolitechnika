const express = require('express');
const crypto = require("crypto");
const mongoose = require('mongoose');
const config = require('./config.js');

mongoose.connect(config.mongodb, { useNewUrlParser: true, useUnifiedTopology: true });
const user = require('./models/user.js');
const grade = require('./models/grade.js');
const group = require('./models/group.js');

const app = express();
let auth = {};

app.use(express.static('public'));
app.use(express.json());
app.use(function (req, res, next) {
  req.session = {};
  let http_auth = req.get('authorization');
  if (http_auth) {
    let token = http_auth.split(' ')[1];
    if (token) {
      let _user = auth[token];
      if (_user) {
        req.session.user = _user; // recreate user session
        req.session.id = token;
      }
    }
  }
  next();
});

function restrict(req, res, next) {
  if (req.session.user) {
    next();
  } else {
    res.json({ msg: "No access!" });
  }
}

app.get('/logged', (req, res) => {
  if (req.session.user) {
    res.json({ msg: "YES" });
  }
  else {
    res.json({ msg: "NO" });
  }
});

app.get('/logout', restrict, (req, res) => {
  delete auth[req.session.id];
  req.session = {};
  res.json({ msg: "OK" });
});

app.post('/login', (req, res) => {
  user.findOne({ 'name': req.body.username }, 'name password', (err, _user) => {
    if (err || !_user) return res.json({ msg: "Error occurs!" });

    if (_user.password !== req.body.password) return res.json({ msg: "Wrong password!" });

    let id = crypto.randomBytes(16).toString("hex"); // generate auth token
    auth[id] = _user;
    res.json({ msg: "OK", token: id });
  });
});

app.post('/register', (req, res) => {
  user.findOne({ 'name': req.body.username }, 'name', (err, _user) => {
    if (err) return res.json({ msg: err });
    if (!_user) {
      user.create({ name: req.body.username, password: req.body.password }, function (err, _user2) {
        if (err) return res.json({ msg: err });
        res.json({ msg: "OK" });
      });
      return;
    }
    res.json({ msg: "Username already taken!" });
  });
});

app.get('/grades/:user', restrict, (req, res) => {
  grade.find({ 'user': req.params['user'] }, 'value subject user', (err, grades) => {
    if (err) return handleError(err);
    res.json(grades);
  });
});

app.put('/grades', restrict, (req, res) => {
  let { user, subject, value } = [req.body.user, req.body.subject, req.body.value];
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

app.delete('/grades', restrict, (req, res) => {
  grade.deleteOne({ 'user': req.body.user, 'subject': req.body.subject }, function (err) {
    if (err) return handleError(err);
    res.json({ msg: "OK" });
  });
});

app.get('/group/:user', restrict, (req, res) => {
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

app.listen(8080, () => {
  console.log('Server listening on port 8080!');
});