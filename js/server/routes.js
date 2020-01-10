const user = require('./models/user.js');
const group = require('./models/group.js');
const table = require('./models/timetable.js');
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

    // get user info
    app.get('/user', auth.restrict, (req, res) => {
        let user = req.session.user;
        res.json({ msg: "OK", user: { _id: user._id, name: user.name, mail: user.mail } });
    });

    // add user extra lesson
    app.put('/user/extralessons', auth.restrict, (req, res) => {
        req.session.user.addExtraLesson(req.body.subject, req.body.day, req.body.hour, req.body.length,
            req.body.type, req.body.classroom, req.body.lecturer, (err, _res) => {
            if(err) return res.json({msg: err});
            res.json({msg: "OK"});
        });
    });

    // get user extra lessons
    app.get('/user/extralessons', auth.restrict, (req, res) => {
        req.session.user.getExtraLessons((err, extralesson) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", extralesson: extralesson });
        });
    });

    //delete user extra lessons
    app.delete('/user/extralessons', auth.restrict, (req,res) => {
        req.session.user.deleteExtraLesson(req.body.subject, req.body.day, req.body.hour, (err, _res) => {
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
        req.session.user.addGrade(req.body.semester, req.body.subject, req.body.ects, req.body.value, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    //update grade
    app.post('/grades', auth.restrict, (req, res) => {
        req.session.user.updateGrade(req.body.semester, req.body.subject, req.body.ects, req.body.value, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    // delete grade
    app.delete('/grades', auth.restrict, (req, res) => {
        req.session.user.deleteGrade(req.body.semester, req.body.subject, (err, _res) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK" });
        });
    });

    // get user group info
    app.get('/group', auth.restrict, (req, res) => {
        req.session.user.getGroup((err, group) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", group: group });
        });
    });

    // set user group
    app.put('/group', auth.restrict, (req, res) => {
        group.findOne({ '_id': req.body.groupid }, (err, _group) => {
            if (err) return res.json({ msg: err });
            req.session.user.setGroup(_group, (err2) => {
                if (err2) return res.json({ msg: err2 });
                res.json({ msg: "OK", group: _group });
            });
        });
    });

    // get group timetable
    app.get('/group/timetable', auth.restrict, (req, res) => {
        req.session.user.getGroup((err, group) => {
            if (err) return res.json({ msg: err });

            group.getTimeTable((err, table) => {
                if (err) return res.json({ msg: err });
                res.json({ msg: "OK", timetable: table });
            });
        });
    });

    // get lecturer timetable
    app.get('/lecturer/:name/timetable', (req, res) => {
        table.find({ 'lecturer': req.params.name }, '', (err, table) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", timetable: table });
        });
    });

    // get room timetable
    app.get('/room/:name/timetable', (req, res) => {
        table.find({ 'classroom': req.params.name }, '', (err, table) => {
            if (err) return res.json({ msg: err });
            res.json({ msg: "OK", timetable: table });
        });
    });

    // search group by text
    app.get('/search/group', auth.restrict, (req, res) => {
        group.find({ $text: { $search: eval(`"${req.query.text}"`) } }, '_id field semester mode')
            .limit(50)
            .exec((err, docs) => {
                if (err) return res.json({ msg: err });
                res.json({ msg: "OK", groups: docs });
            });
    });

    // search place, subject or lecturer
    app.get('/search/timetable', auth.restrict, (req, res) => {
        table.find({ $text: { $search: eval(`"${req.query.text}"`) }, group: req.session.user.group })
            .limit(50)
            .exec((err, docs) => {
                if (err) return res.json({ msg: err });
                res.json({ msg: "OK", timetable: docs });
            });
    });
}