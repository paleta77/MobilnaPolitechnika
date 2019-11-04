const express = require('express');
const mongoose = require('mongoose');
const config = require('./config.js');
const auth = require('./auth.js');

mongoose.connect(config.mongodb, { useNewUrlParser: true, useUnifiedTopology: true });

const app = express();

app.use(express.static('public'));
app.use(express.json());
app.use(auth.check);

require('./routes.js')(app);

app.listen(8080, () => {
  console.log('Server listening on port 8080!');
});