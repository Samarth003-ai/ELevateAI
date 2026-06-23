/**
 * Calculates matching score between a user's Profile and a JSearch job result.
 * 
 * @param {Object} profile - User profile document (with skills and experience)
 * @param {Object} job - JSearch job object (with job_title, job_description)
 * @returns {Object} { score: number, matchedSkills: string[] }
 */
const calculateProfileMatch = (profile, job) => {
  if (!profile) {
    return { score: 0, matchedSkills: [] };
  }

  const profileSkills = (profile.skills || []).map(s => s.toLowerCase().trim()).filter(Boolean);
  const jobTitle = (job.job_title || "").toLowerCase();
  const jobDescription = (job.job_description || "").toLowerCase();

  // 1. Skill Overlap Matching (60% weight)
  let matchedSkills = [];
  if (profileSkills.length > 0) {
    matchedSkills = profileSkills.filter(skill => {
      // Create word boundary search or simple containment check
      return jobDescription.includes(skill) || jobTitle.includes(skill);
    });
  }

  const skillScore = profileSkills.length > 0 
    ? (matchedSkills.length / profileSkills.length) * 60 
    : 0;

  // 2. Experience Role Matching (40% weight)
  let experienceScore = 0;
  const experienceList = profile.experience || [];
  if (experienceList.length > 0) {
    const roles = experienceList.map(exp => (exp.role || "").toLowerCase().trim()).filter(Boolean);
    for (const role of roles) {
      // Check if job title contains the role name or vice-versa
      if (jobTitle.includes(role) || role.includes(jobTitle)) {
        experienceScore = 40;
        break;
      }
    }
  } else {
    // If no experience listed, distribute some weight if their profile bio matches the job title fields
    const bioText = (profile.bio || "").toLowerCase();
    if (bioText && (jobTitle.includes(bioText) || bioText.includes(jobTitle))) {
      experienceScore = 20;
    }
  }

  const finalScore = Math.min(100, Math.round(skillScore + experienceScore));

  // Map matchedSkills back to original casing from profile
  const matchedOriginalSkills = (profile.skills || []).filter(s => 
    matchedSkills.includes(s.toLowerCase().trim())
  );

  return {
    score: finalScore,
    matchedSkills: matchedOriginalSkills
  };
};

module.exports = {
  calculateProfileMatch
};
