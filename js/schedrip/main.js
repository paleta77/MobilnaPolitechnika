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
    for (let page of data.formImage.Pages) {
        console.log("Page");
        let subjects = [];
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
        }
        for (let sub of subjects) {
            if (sub.y >  page.HLines[3].y - 0.1)
                sub.day = "niedziela";
            else
                sub.day = "sobota";

            console.log("\t" + sub.day + "|" + sub.text + "|" + sub.body.join("|"));
        }

    }
});

pdfParser.loadPDF("./test.pdf");