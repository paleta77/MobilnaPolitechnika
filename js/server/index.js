const express = require('express');
var session = require('express-session');
const app = express();

app.use(express.urlencoded({ extended: false }))
app.use(session({
  resave: false,
  saveUninitialized: false,
  secret: '12345'
}));

// users database, temporary here :/ 
let users = { "admin": { name: "admin:", password: "1234" } };

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
  let user = users[req.body.username];
  if (!user) {
    res.json({ msg: "No such user!" });
    return;
  }
  if (user.password !== req.body.password) {
    res.json({ msg: "Wrong password!" });
    return;
  }

  req.session.regenerate(() => {
    req.session.user = user;
    res.json({msg:"OK"});
  });
});

app.listen(8000, () => {
  console.log('Server listening on port 8000!');
});