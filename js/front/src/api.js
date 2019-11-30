import * as http from './http.js';

export default {

    token: localStorage.getItem('token'),

    msg: "",

    logged: async function () {
        const logged = await http.get('logged', { "Authorization": `Bearer ${this.token}` });
        this.msg = logged.msg;
        if (logged.msg != 'YES') {
            localStorage.removeItem('token');
            this.token = null;
            return false;
        }
        return true;
    },

    login: async function (username, password) {
        const data = await http.post('login', { username: username, password: password });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            localStorage.setItem('token', data.token);
            this.token = data.token;
            return true;
        }
        return false;
    },

    logout: async function () {
        const data = await http.get('logout', { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            localStorage.removeItem('token');
            this.token = null;
            return true;
        }
        return false;
    },

    userInfo: async function () {
        const data = await http.get('user', { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return data.user;
        }
        return null;
    },

    userGroup: async function () {
        const data = await http.get('group', { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return data.group;
        }
        return null;
    },

    timetable: async function () {
        const data = await http.get('group/timetable', { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        console.log(data);
        if (data.msg == 'OK') {
            return data.timetable;
        }
        return null;
    },

    getGrades: async function (username) {
        const data = await http.get('grades', { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return data.grades;
        }
        return null;
    },

    deleteGrade: async function (username, subject) {
        const data = await http.del('grades', { user: username, subject: subject }, { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return true;
        }
        return false;
    },

    addGrade: async function (username, subject, value) {
        const data = await http.put('grades', { user: username, subject: subject, value: value }, { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return true;
        }
        return false;
    },

    changeGrade: async function (username, subject, value) {
        const data = await http.post('grades', { user: username, subject: subject, value: value }, { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return true;
        }
        return false;
    },

    search: async function (text) {
        const data = await http.get(`search?text=${text}`, { "Authorization": `Bearer ${this.token}` });
        this.msg = data.msg;
        if (data.msg == 'OK') {
            return data.result;
        }
        return null;
    }
}