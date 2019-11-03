const mongoose = require('mongoose');

module.exports = {
    schema: new mongoose.Schema({ day: String, hour:Number, length:Number, subject:String, classroom: String, lecturer: String }),
};