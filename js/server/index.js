const express = require('express');
const mongoose = require('mongoose');
const sendgrid = require('@sendgrid/mail');
const swagger = require('swagger-ui-express');
const YAML = require('yamljs');
const auth = require('./auth.js');

const config = require('./config.js');
mongoose.connect(config.mongodb, { useCreateIndex: true, useNewUrlParser: true, useUnifiedTopology: true }).catch(error => handleError(error));
sendgrid.setApiKey(config.sendgridkey);
delete config;

const app = express();

app.use(express.static('public'));
app.use(express.json());
app.use(auth.check);
app.use('/api-docs', swagger.serve, swagger.setup(YAML.load('./swagger.yaml')));

require('./routes.js')(app);

app.listen(8079, () => {
  console.log('Server listening on port 8079!');
});
