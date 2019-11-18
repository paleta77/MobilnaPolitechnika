import * as http from './http.js';

export let token = localStorage.getItem('token');

export let msg = "";

export async function logged() {
    const logged = await http.get('logged', { "Authorization": `Bearer ${token}` });
    msg = logged.msg;
    if (logged.msg != 'YES') {
        localStorage.removeItem('token');
        token = null;
        return false;
    }
    return true;
}

export async function login(username, password) {
    const data = await http.post('login', { username: username, password: password });
    msg = data.msg;
    if (data.msg == 'OK') {
        localStorage.setItem('token', data.token);
        token = data.token;
        return true;
    }
    return false;
}

export async function logout() {
    const data = await http.get('logout', { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        localStorage.removeItem('token');
        token = null;
        return true;
    }
    return false;
}

export async function userInfo() {
    const data = await http.get('user', { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return data.user;
    }
    return null;
}

export async function userGroup() {
    const data = await http.get('group', { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return data.group;
    }
    return null;
}

export async function getGrades(username) {
    const data = await http.get('grades', { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return data.grades;
    }
    return null;
}

export async function deleteGrade(username, subject) {
    const data = await http.del('grades', { user: username, subject: subject }, { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return true;
    }
    return false;
}

export async function addGrade(username, subject, value) {
    const data = await http.put('grades', { user: username, subject: subject, value: value }, { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return true;
    }
    return false;
}

export async function changeGrade(username, subject, value) {
    const data = await http.post('grades', { user: username, subject: subject, value: value }, { "Authorization": `Bearer ${token}` });
    msg = data.msg;
    if (data.msg == 'OK') {
        return true;
    }
    return false;
}