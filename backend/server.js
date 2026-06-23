const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const authRoutes = require("./src/routes/authRoutes")
const userRoutes = require("./src/routes/userRoutes")
// profileRoutes will be loaded later with error handling
const applicationRoutes =
    require("./src/routes/applicationRoutes");
const resumeRoutes = require("./src/routes/resumeRoutes");
const templateRoutes = require("./src/routes/templateRoutes");
const pdfRoutes = require("./src/routes/pdfRoutes");
const jobRoutes =
    require("./src/routes/jobRoutes");
const savedJobRoutes =
    require("./src/routes/savedJobRoutes");


const connectDB = require("./src/config/db");

dotenv.config();

connectDB();

const app = express();
app.use(cors());
app.use(express.json());  //tells express to understand json 
app.use(
    "/api/applications",
    applicationRoutes
);
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/resumes", resumeRoutes);
app.use("/api/templates", templateRoutes);
app.use("/api/pdf", pdfRoutes);
app.use(
    "/api/jobs",
    jobRoutes
);
app.use(
    "/api/saved-jobs",
    savedJobRoutes
);


let profileRoutes;
try {
    profileRoutes = require("./src/routes/profileRoutes");
} catch (err) {
    console.error("Failed to load profileRoutes:", err);
    process.exit(1);
}
app.use("/api/profile", profileRoutes);

app.get("/", (req, res) => {
    res.send("CareerConnect API Running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(
        `Server running on port ${PORT}`
    );
});