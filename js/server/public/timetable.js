import * as api from "./api.js";

function zero2(number) {
    return ("" + number).padStart(2, '0');
}

function strhour(hour) {
    return zero2(hour[0]) + ":" + zero2(hour[1]);
}

function addMinutes(date, minutes) {
    return [date[0] + ((date[1] + minutes) / 60) | 0, ((date[1] + minutes) % 60) | 0];
}

function toHour(float) {
    return [float | 0, ((float % 1) * 100) | 0];
}

export async function loadTimetable() {
    $("#loading").show();
    let timetable = await api.timetable();

    if (timetable === null) {
        return alert(api.msg);
    }

    $('#timetable').empty();

    let i = 1;
    for (let el of timetable) {
        let start = toHour(el.hour);
        let end = addMinutes(start, el.length);

        let x = (el.day == "Sobota" ? 0 : 430) + 100;
        let y = 80 * (start[0] + (start[1] / 60) - 8) + 12 + 20;
        let height = (8 * el.length) / 6;
        $('#timetable').append(`
        <div class="card" style="top:${y}px;left:${x}px;min-height:${height}px">
            <div class="header">${strhour(start)} - ${strhour(end)}</div>
            ${el.subject}
            <br/>
            <b>${el.lecturer ? el.lecturer : ""}</b>
            <br />
            <a href="#" onclick="showMap('${el.classroom}')"><b>${el.classroom}</b></a>
        </div>`);
        i++;
    }

    $("#loading").hide();
}