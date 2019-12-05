const fs = require('fs');
const PDFParser = require("pdf2json");
const _ = require('pdf2json/node_modules/lodash');

function isSubjectType(text) {
    return text.startsWith("Laboratorium") || text.startsWith("Wykład") || text.startsWith("Projekt") || text.startsWith("Lektorat");
}

function splitSubjects(lines) {
    let result = [];
    for (let line of lines) {
        if (isSubjectType(line.text)) {
            line.body = [];
            result.push(line);
        }
        else {
            result[result.length - 1].body.push(line.text);
        }
    }
    return result;
}

let pdfParser = new PDFParser();
pdfParser.on("pdfParser_dataError", err => console.error("Error: " + err.parserError));
pdfParser.on("pdfParser_dataReady", data => {
    let schedules = {};
    for (let page of data.formImage.Pages) {
        console.log("Page");
        let subjects = [];
        let group = "no_group";
        for (let el of page.Texts) {
            let text = decodeURIComponent(el.R[0].T);
            if (isSubjectType(text)) {
                let lines = [];

                for (let subel of page.Texts) {
                    if (subel.x == el.x)
                        lines.push({ x: subel.x, y: subel.y, text: decodeURIComponent(subel.R[0].T) });
                }

                for (let sub of splitSubjects(lines))
                    subjects.push(sub);
            }
            else if (text.includes("Grupa Rozkład")) {
                group = text.split("-")[1].trim();
            }
        }

        for (let sub of subjects) {
            if (sub.y > page.HLines[3].y - 0.1)
                sub.day = "Niedziela";
            else
                sub.day = "Sobota";

            sub.type = sub.text.split(", ")[0];
            sub.start = sub.text.split(", ")[1].split("-")[0];
            sub.end = sub.text.split(", ")[1].split("-")[1];

            if (_.last(sub.body).includes("zjazd")) {
                sub.info = sub.body.pop(); // move additional info
            }

            sub.room = sub.body.pop();

            let part_group_name = group.split("_").slice(0, -1).join("_");
            sub.name = "";
            while (!_.first(sub.body).includes(part_group_name))
                sub.name += sub.body.shift() + " ";
            sub.name = sub.name.trim();

            sub.group = sub.body.shift(); // might be multiline

            sub.lecturer = sub.body.join(" ");

            delete sub.body;
            delete sub.x;
            delete sub.y;
            delete sub.text;
        }

        subjects = subjects.filter((sub, index, self) =>
            index === self.findIndex((t) => (
                t.day === sub.day && t.type === sub.type && t.name === sub.name && t.start === sub.start
            ))
        );

        schedules[group] = subjects;
    }
    console.log(schedules);
});

pdfParser.loadPDF("./test.pdf");