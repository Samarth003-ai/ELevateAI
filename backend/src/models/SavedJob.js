const mongoose = require("mongoose");

const savedJobSchema =
    new mongoose.Schema({

        user: {
            type:
                mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        jobId: String,

        title: String,

        company: String,

        location: String,

        applyLink: String,

    }, {
        timestamps: true,
    });

module.exports =
    mongoose.model(
        "SavedJob",
        savedJobSchema
    );