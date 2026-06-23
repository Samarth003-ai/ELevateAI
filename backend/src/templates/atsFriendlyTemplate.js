const atsFriendlyTemplate = (resume) => {
  const personalInfo = resume.personalInfo || {};
  const education = resume.education || [];
  const projects = resume.projects || [];
  const skills = resume.skills || [];
  const experience = resume.experience || [];

  const formattedContact = [
    personalInfo.email,
    personalInfo.phone,
    personalInfo.address,
    personalInfo.linkedin,
    personalInfo.github
  ].filter(Boolean).join("  |  ");

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        body {
          font-family: 'Calibri', 'Arial', sans-serif;
          margin: 0;
          padding: 40px;
          color: #333333;
          font-size: 11pt;
          line-height: 1.4;
          background-color: #ffffff;
        }
        .header {
          text-align: center;
          margin-bottom: 25px;
        }
        .name {
          font-size: 24pt;
          font-weight: bold;
          color: #000000;
          margin: 0 0 5px 0;
          text-transform: uppercase;
          letter-spacing: 1px;
        }
        .contact {
          font-size: 10pt;
          color: #555555;
          margin-bottom: 15px;
        }
        .section-title {
          font-size: 12pt;
          font-weight: bold;
          color: #000000;
          text-transform: uppercase;
          border-bottom: 1px solid #333333;
          margin-top: 22px;
          margin-bottom: 10px;
          padding-bottom: 2px;
          letter-spacing: 0.5px;
        }
        .summary {
          margin-bottom: 15px;
          text-align: justify;
        }
        .item {
          margin-bottom: 15px;
        }
        .item-header {
          display: flex;
          justify-content: space-between;
          font-weight: bold;
          color: #000000;
        }
        .item-sub {
          display: flex;
          justify-content: space-between;
          font-style: italic;
          color: #444444;
          margin-top: 2px;
          margin-bottom: 6px;
        }
        .item-desc {
          margin: 0;
          padding-left: 20px;
          text-align: justify;
        }
        .item-desc li {
          margin-bottom: 4px;
        }
        .skills-section {
          margin-bottom: 15px;
        }
        .skills-list {
          margin: 0;
          padding: 0;
          list-style: none;
        }
        .skills-list li {
          display: inline;
        }
        .skills-list li:not(:last-child):after {
          content: ", ";
        }
      </style>
    </head>
    <body>
      <div class="header">
        <h1 class="name">${personalInfo.name || "YOUR NAME"}</h1>
        <div class="contact">${formattedContact}</div>
      </div>

      ${resume.summary ? `
        <div class="section-title">Professional Summary</div>
        <div class="summary">${resume.summary}</div>
      ` : ""}

      ${skills.length > 0 ? `
        <div class="section-title">Skills & Expertise</div>
        <div class="skills-section">
          <ul class="skills-list">
            ${skills.map(skill => `<li><strong>${skill}</strong></li>`).join("")}
          </ul>
        </div>
      ` : ""}

      ${experience.length > 0 ? `
        <div class="section-title">Professional Experience</div>
        ${experience.map(exp => `
          <div class="item">
            <div class="item-header">
              <span>${exp.company || ""}</span>
              <span>${exp.duration || ""}</span>
            </div>
            <div class="item-sub">
              <span>${exp.role || ""}</span>
            </div>
            ${exp.description ? `
              <ul class="item-desc">
                ${exp.description.split('\n').filter(Boolean).map(bullet => `
                  <li>${bullet.replace(/^[•\-\*\s]+/, '')}</li>
                `).join("")}
              </ul>
            ` : ""}
          </div>
        `).join("")}
      ` : ""}

      ${projects.length > 0 ? `
        <div class="section-title">Key Projects</div>
        ${projects.map(proj => `
          <div class="item">
            <div class="item-header">
              <span>${proj.title || ""}</span>
            </div>
            ${proj.techStack && proj.techStack.length > 0 ? `
              <div class="item-sub">
                <span>Technologies: ${proj.techStack.join(", ")}</span>
              </div>
            ` : ""}
            ${proj.description ? `
              <ul class="item-desc">
                ${proj.description.split('\n').filter(Boolean).map(bullet => `
                  <li>${bullet.replace(/^[•\-\*\s]+/, '')}</li>
                `).join("")}
              </ul>
            ` : ""}
          </div>
        `).join("")}
      ` : ""}

      ${education.length > 0 ? `
        <div class="section-title">Education</div>
        ${education.map(edu => `
          <div class="item">
            <div class="item-header">
              <span>${edu.college || ""}</span>
              <span>${edu.duration || ""}</span>
            </div>
            <div class="item-sub">
              <span>${edu.degree || ""}</span>
              ${edu.cgpa ? `<span>GPA: ${edu.cgpa}</span>` : ""}
            </div>
          </div>
        `).join("")}
      ` : ""}
    </body>
    </html>
  `;
};

module.exports = atsFriendlyTemplate;
