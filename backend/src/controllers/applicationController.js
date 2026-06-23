const Application =
    require("../models/Application");

const createApplication =
    async (req, res) => {

        const {
            title,
            company,
        } = req.body;

        const existing =
            await Application.findOne({
                user: req.user.userId,
                title,
                company,
            });

        if (existing) {
            return res.status(400).json({
                success: false,
                message: "Already tracked",
            });
        }

        const application =
            await Application.create({

                user:
                    req.user.userId,

                title,

                company,
            });

        res.status(201).json({
            success: true,
            application,
        });
    };


const getApplications =
    async (req, res) => {

        const applications =
            await Application.find({

                user:
                    req.user.userId,

            }).sort({
                createdAt: -1,
            });

        res.json({
            success: true,
            applications,
        });
    };

const updateApplication =
    async (req, res) => {

        const application =
            await Application.findOneAndUpdate(

                {
                    _id: req.params.id,

                    user:
                        req.user.userId,
                },

                {
                    status:
                        req.body.status,
                },

                {
                    new: true,
                }
            );

        res.json({
            success: true,
            application,
        });
    };

const deleteApplication =
    async (req, res) => {

        await Application
            .findOneAndDelete({

                _id: req.params.id,

                user:
                    req.user.userId,
            });

        res.json({
            success: true,
        });
    };

module.exports = {

    createApplication,

    getApplications,

    updateApplication,

    deleteApplication,
};