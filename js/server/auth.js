const crypto = require("crypto");
const user = require("./models/user.js");

exports = module.exports = {
    sessions: {},
    check: function (req, res, next) {
        req.session = {};
        let http_auth = req.get('authorization');
        if (http_auth) {
            let token = http_auth.split(' ')[1];
            if (token) {
                let _user = exports.sessions[token];
                if (_user) {
                    req.session.user = _user; // recreate user session
                    req.session.id = token;
                }
            }
        }
        next();
    },

    restrict: function (req, res, next) {
        if (req.session.user) {
            next();
        } else {
            res.json({ msg: "No access!" });
        }
    },

    genToken: function () {
        return crypto.randomBytes(16).toString("hex");
    }

}

// remove me after testing
user.findOne({ 'name': 'admin' }, (err, _user) => {
    if (err || !_user) return;
    exports.sessions['123'] = _user;
});