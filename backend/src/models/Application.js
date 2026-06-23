const mongoose =
    require("mongoose");

const applicationSchema =
    new mongoose.Schema({

        user: {

            type:
                mongoose.Schema.Types.ObjectId,

            ref: "User",

            required: true,
        },

        title: {

            type: String,

            required: true,
        },

        company: String,

        status: {

            type: String,

            enum: [
                "Applied",
                "Interview",
                "Rejected",
                "Offer",
                "Accepted",
            ],

            default:
                "Applied",
        },

        notes: {

            type: String,

            default: "",
        },

        appliedDate: {

            type: Date,

            default:
                Date.now,
        },

    }, {
        timestamps: true,
    });

module.exports =
    mongoose.model(
        "Application",
        applicationSchema,
    );