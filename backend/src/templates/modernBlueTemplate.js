const modernBlueTemplate = (resume) => {
  const personalInfo = resume.personalInfo || {};
  const education = resume.education || [];
  const projects = resume.projects || [];
  const skills = resume.skills || [];
  const experience = resume.experience || [];

  const formattedContact = [
    personalInfo.email && `<div><strong>Email:</strong> ${personalInfo.email}</div>`,
    personalInfo.phone && `<div><strong>Phone:</strong> ${personalInfo.phone}</div>`,
    personalInfo.address && `<div><strong>Address:</strong> ${personalInfo.address}</div>`,
    personalInfo.linkedin && `<div><strong>LinkedIn:</strong> ${personalInfo.linkedin}</div>`,
    personalInfo.github && `<div><strong>GitHub:</strong> ${personalInfo.github}</div>`
  ].filter(Boolean).join("");

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <style>
        * {
          box-sizing: border-box;
        }
        body {
          font-family: 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
          margin: 0;
          padding: 0;
          color: #333333;
          font-size: 10pt;
          line-height: 1.4;
          background-color: #ffffff;
        }
        .container {
          display: flex;
          min-height: 297mm;
        }
        .sidebar {
          width: 32%;
          background-color: #f4f6f9;
          padding: 30px 20px;
          border-right: 1px solid #e1e4e8;
        }
        .main {
          width: 68%;
          padding: 30px 25px;
        }
        .name {
          font-size: 22pt;
          font-weight: 800;
          color: #1a365d;
          margin: 0 0 5px 0;
          line-height: 1.1;
        }
        .title {
          font-size: 11pt;
          font-weight: 600;
          color: #2b6cb0;
          margin-bottom: 25px;
          text-transform: uppercase;
          letter-spacing: 1px;
        }
        .section-title {
          font-size: 12pt;
          font-weight: 700;
          color: #1a365d;
          border-bottom: 2px solid #2b6cb0;
          padding-bottom: 3px;
          margin-top: 22px;
          margin-bottom: 12px;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }
        .sidebar .section-title {
          border-bottom: 2px solid #cbd5e0;
          color: #2d3748;
        }
        .contact-info {
          margin-top: 15px;
        }
        .contact-info div {
          margin-bottom: 10px;
          font-size: 9pt;
          color: #4a5568;
          word-break: break-all;
        }
        .contact-info strong {
          color: #1a365d;
        }
        .skill-tag {
          display: inline-block;
          background-color: #e2e8f0;
          color: #2d3748;
          padding: 4px 8px;
          border-radius: 4px;
          margin: 3px;
          font-size: 8.5pt;
          font-weight: 500;
        }
        .item {
          margin-bottom: 18px;
        }
        .item-header {
          display: flex;
          justify-content: space-between;
          font-weight: 700;
          color: #2d3748;
          font-size: 10.5pt;
        }
        .item-sub {
          display: flex;
          justify-content: space-between;
          font-style: italic;
          color: #4a5568;
          font-size: 9.5pt;
          margin-top: 2px;
          margin-bottom: 6px;
        }
        .item-desc {
          margin: 0;
          padding-left: 18px;
          font-size: 9.5pt;
          color: #4a5568;
          text-align: justify;
        }
        .item-desc li {
          margin-bottom: 3px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
          <h1 class="name">${personalInfo.name || "YOUR NAME"}</h1>
          <div class="title">Resume</div>
          
          <div class="section-title">Contact Info</div>
          <div class="contact-info">
            ${formattedContact}
          </div>

          ${skills.length > 0 ? `
            <div class="section-title">Skills</div>
            <div style="margin-top: 10px;">
              ${skills.map(skill => `<span class="skill-tag">${skill}</span>`).join("")}
            </div>
          ` : ""}
        </div>

        <!-- Main Content -->
        <div class="main">
          ${resume.summary ? `
            <div class="section-title" style="margin-top: 0;">Professional Summary</div>
            <p style="margin: 0 0 20px 0; text-align: justify; font-size: 9.5pt; color: #4a5568;">
              ${resume.summary}
            </p>
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
        </div>
      </div>
    </body>
    </html>
  `;
};

module.exports = modernBlueTemplate;