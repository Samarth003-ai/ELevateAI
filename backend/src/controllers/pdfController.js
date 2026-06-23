const puppeteer = require("puppeteer");

const Resume = require("../models/Resume");
const modernBlueTemplate = require("../templates/modernBlueTemplate");
const atsFriendlyTemplate = require("../templates/atsFriendlyTemplate");

const generatePDF = async (req, res) => {
    try {
        const resume = await Resume.findOne({
            _id: req.params.id,
            user: req.user.userId
        });

        if (!resume) {
            return res.status(404).json({
                message: "Resume not found"
            });
        }

        const templateMap = {
            modern_blue: modernBlueTemplate,
            ats_friendly: atsFriendlyTemplate,
        };
        const templateFn = templateMap[resume.template] || atsFriendlyTemplate;
        const html = templateFn(resume);

        //launch chrome(pupperteer does this secretely)

        const browser = await puppeteer.launch();

        //create page
        const page = await browser.newPage();

        await page.setContent(      //fill page with html/ rendering
            html, {
            waitUntil: "networkidle0"
        }
        );
        //gen pdf
        const pdf = await page.pdf({    // here pdf stores raw binary pdf bytes
            format: "A4",
            printBackground: true,
        });

        await browser.close();
        //set headers
        res.set({
            "Content-Type":
                "application/pdf",       //res is pdf format

            "Content-Disposition":              //tells to downlaod file not display it
                `attachment; filename="${resume.title}.pdf"`
        });

        res.send(pdf);

    } catch (error) {
        res.status(500).json({
            message: error.message,
        })
    }
};

module.exports = {
    generatePDF,
}