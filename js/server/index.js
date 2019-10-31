const express = require('express');
const crypto = require("crypto");
const mongoose = require('mongoose');
const config = require('./config.js');

const app = express();

mongoose.connect(config.mongodb, { useNewUrlParser: true, useUnifiedTopology: true });

const user = require('./user.js');
const grade = require('./grade.js');
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

app.get('/restricted', restrict, (req, res) => {
  res.json({ msg: "Secret here :)" });
});

app.get('/logout', (req, res) => {
  delete auth[req.session.id];
  req.session = {};
  res.json({ msg: "OK" });
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

app.get('/grades/:user', (req, res) => {
  grade.getAll(req.params['user'], res);
});

app.listen(8080, () => {
  console.log('Server listening on port 8080!');
});