const SavedJob =
    require("../models/SavedJob");

const saveJob =
    async (req, res) => {

        try {

            const {
                jobId,
                title,
                company,
                location,
                applyLink,
            } = req.body;

            const savedJob =
                await SavedJob.create({

                    user:
                        req.user.userId,

                    jobId,

                    title,

                    company,

                    location,

                    applyLink,
                });

            res.status(201).json({

                success: true,

                savedJob,
            });

        } catch (error) {

            res.status(500).json({

                success: false,

                message:
                    error.message,
            });
        }
    };

const getSavedJobs =
    async (req, res) => {

        try {

            const jobs =
                await SavedJob.find({

                    user:
                        req.user.userId,

                }).sort({
                    createdAt: -1,
                });

            res.status(200).json({

                success: true,

                jobs,
            });

        } catch (error) {

            res.status(500).json({

                success: false,

                message:
                    error.message,
            });
        }
    };


const deleteSavedJob =
    async (req, res) => {

        try {

            await SavedJob.findOneAndDelete({

                _id:
                    req.params.id,

                user:
                    req.user.userId,
            });

            res.status(200).json({

                success: true,

                message:
                    "Job removed",
            });

        } catch (error) {

            res.status(500).json({

                success: false,

                message:
                    error.message,
            });
        }
    };

module.exports = {
    saveJob,
    getSavedJobs,
    deleteSavedJob,
};