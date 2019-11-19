import * as api from "./api.js";
import * as timetable from "./timetable.js";

$("#loading").show();

let username = localStorage.getItem('username');
isLogged();

async function isLogged() {
    if (!(await api.logged())) {
        localStorage.removeItem('username');
        username = null;
    }
    showHide();
    $("#loading").hide();
}

function showHide() {
    if (api.token != null) {
        $("#logged").show();
        $("#notlogged").hide();
        $("#welcomeText").text(`Welcome ${username} :)`);
        loadGrades();
        changePage(0);
        timetable.loadTimetable();
    }
    else {
        $("#logged").hide();
        $("#notlogged").show();
    }
}

function changePage(idx) {
    $("#homePage").hide();
    $("#gradesPage").hide();
    $("#tablePage").hide();
    $("#mapPage").hide();

    if(idx === 0) {
        $("#homePage").show();
    } else if(idx===1) {
        $("#gradesPage").show();
    } else if(idx==2){
        $("#tablePage").show();
    }else {
        $("#mapPage").show();
    }
}
window.changePage = changePage;

async function login() {
    $("#loading").show();

    username = $("#username").val();

    if (await api.login(username, $("#password").val())) {
        localStorage.setItem('username', username);
        showHide();
    }
    else {
        alert(api.msg);
    }

    $("#loading").hide();
};
window.login = login;

async function logout() {
    $("#loading").show();

    await api.logout();
    localStorage.removeItem('username');
    username = null;
    showHide();

    $("#loading").hide();
};
window.logout = logout;

async function loadGrades() {
    let grades = await api.getGrades(username);

    $('#gradesTable tbody').empty();

    let sum = 0;
    let i = 1;
    for (let grade of grades) {
        $('#gradesTable tbody').append(`
        <tr>
            <td>${i}</td>
            <td>${grade.subject}</td>
            <td>${grade.value}</td>
            <td>
                <button class="btn btn-primary" onclick="openChangeGrade('${grade.subject}', ${grade.value});">✎</button>
                <button class="btn btn-primary" onclick="deleteGrade('${grade.subject}');">🗑</button>
            </td>
        </tr>`);
        i++;
        sum += grade.value;
    }

    if (i == 1) {
        $('#gradesTable tbody').append(`<tr><td colspan="4">None</td></tr>`);
    } else {
        let average = sum / (i - 1);
        $('#gradesTable tbody').append(`<tr><td colspan="4">average: ${average}</td></tr>`);
    }
}

async function deleteGrade(subject) {
    await api.deleteGrade(username, subject);
    loadGrades();
}
window.deleteGrade = deleteGrade;

async function addGrade() {
    let subject = $('#subjectInput').val();
    let value = parseFloat($('#valueInput').val());
    await api.addGrade(username, subject, value);
    loadGrades();
}
window.addGrade = addGrade;

function openChangeGrade(subject, value) {
    $('#changeGradeModal').modal('show');
    $('#subjectInputChange').val(subject);
    $('#valueInputChange').val(value);
}
window.openChangeGrade = openChangeGrade;

async function changeGrade() {
    await api.changeGrade(username, $('#subjectInputChange').val(), $('#valueInputChange').val());
    $('#changeGradeModal').modal('hide');
    loadGrades();
}
window.changeGrade = changeGrade;

async function showMap(target) {
    //$("#mapframe").attr('src', `nav/?target=${target}`);
    document.getElementById("mapframe").contentWindow.setTarget(target);
    changePage(3);
}
window.showMap = showMap;

