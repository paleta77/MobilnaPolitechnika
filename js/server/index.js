const express = require('express');
const crypto = require("crypto");
const mongoose = require('mongoose');
const config = require('./config.js');

const app = express();

mongoose.connect(config.mongodb, { useNewUrlParser: true, useUnifiedTopology: true });

const user = require('./user.js');
let auth = {};

app.use(express.static('public'));
app.use(express.json());
app.use(function (req, res, next) {
  req.session = {};
  if (req.body.token) {
    let _user = auth[req.body.token];
    if (_user) {
      req.session.user = _user; // recreate user session
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

app.post('/restricted', restrict, (req, res) => {
  res.json({ msg: "Secret here :)" });
});

app.post('/logout', (req, res) => {
  req.session = {};
  res.json({ msg: "OK"});
});

app.post('/login', (req, res) => {
  user.findOne({ 'name': req.body.username }, 'name password', (err, _user) => {
    if (err || !_user) {
      res.json({ msg: "Error occurs!" });
      return;
    }

    if (_user.password !== req.body.password) {
      res.json({ msg: "Wrong password!" });
      return;
    }

    let id = crypto.randomBytes(16).toString("hex"); // generate auth token
    auth[id] = _user;
    res.json({ msg: "OK", token: id });
  });
});

app.listen(8080, () => {
  console.log('Server listening on port 8080!');
});