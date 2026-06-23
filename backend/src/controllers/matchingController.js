const Profile = require("../models/profile");
const { searchJobs } = require("../services/jobService");
const { calculateProfileMatch } = require("../services/matchingService");

const getMatchedJobs = async (req, res) => {
  try {
    const userId = req.user.userId;

    // 1. Fetch user profile
    const profile = await Profile.findOne({ user: userId });

    if (!profile || !profile.skills || profile.skills.length === 0) {
      return res.status(200).json({
        success: true,
        message: "Please complete your profile and add skills to receive job recommendations.",
        query: "",
        jobs: []
      });
    }

    // 2. Formulate search query based on profile
    let query = "";
    if (profile.experience && profile.experience.length > 0) {
      // Find the first experience role that is non-empty
      const latestExp = profile.experience.find(exp => exp.role);
      if (latestExp) {
        query = latestExp.role;
      }
    }

    // If query is still empty, use the first two skills
    if (!query && profile.skills && profile.skills.length > 0) {
      query = profile.skills.slice(0, 2).join(" ");
    }

    // Fallback if everything is empty
    if (!query) {
      query = "Software Developer";
    }

    // 3. Search jobs using current searchJobs service wrapper
    console.log(`Matching jobs for user: ${userId} using query: "${query}"`);
    const jobsResult = await searchJobs(query);
    const rawJobs = jobsResult.data || [];

    // 4. Calculate match score for each job
    const matchedJobs = rawJobs.map(job => {
      const matchResult = calculateProfileMatch(profile, job);
      return {
        job_id: job.job_id,
        employer_name: job.employer_name,
        employer_logo: job.employer_logo,
        job_title: job.job_title,
        job_description: job.job_description,
        job_location: job.job_location || job.job_city || "Remote/Unspecified",
        job_apply_link: job.job_apply_link,
        matchScore: matchResult.score,
        matchedSkills: matchResult.matchedSkills
      };
    });

    // 5. Filter out extremely low-scoring matches and sort descending
    const filteredJobs = matchedJobs
      .filter(job => job.matchScore >= 10)
      .sort((a, b) => b.matchScore - a.matchScore);

    res.status(200).json({
      success: true,
      query,
      jobs: filteredJobs
    });

  } catch (error) {
    console.error("Error in getMatchedJobs:", error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

module.exports = {
  getMatchedJobs
};
