const express = require('express');
const session = require('express-session');
const mongoose = require('mongoose');
const app = express();

mongoose.connect('mongodb://db/', { useNewUrlParser: true, useUnifiedTopology: true });

const user = require('./user.js');

app.use(express.urlencoded({ extended: false }))
app.use(session({
  resave: false,
  saveUninitialized: false,
  secret: '12345'
}));

function restrict(req, res, next) {
  if (req.session.user) {
    next();
  } else {
    res.json({ msg: "No access!" });
  }
}

app.get('/', (req, res) => {
  if (!req.session.user) {
    res.json({ msg: "Please login" });
  } else {
    res.json({ msg: "You are logged Sir :)" });
  }
});

app.get('/restricted', restrict, (req, res) => {
  res.json({ msg: "Secret here :)" });
});

app.get('/logout', (req, res) => {
  req.session.destroy(() => {
    res.redirect('/');
  });
});

app.post('/login', (req, res) => {
  user.findOne({ 'name': req.body.username }, 'name password', (err, _user) => {
    if (err || !_user) 
    {
      res.json({ msg: "Error occurs!" });
      return;
    }

    if (_user.password !== req.body.password) {
      res.json({ msg: "Wrong password!" });
      return;
    }

    req.session.regenerate(() => {
      req.session.user = _user;
      res.json({ msg: "OK" });
    });
  });
});

app.listen(8000, () => {
  console.log('Server listening on port 8000!');
});