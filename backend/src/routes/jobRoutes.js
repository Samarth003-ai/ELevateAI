const express =
    require("express");

const router =
    express.Router();

const protect =
    require("../middleware/authMiddleware");

const {
    getJobs,
} = require(
    "../controllers/jobControllers"
);

const {
    getMatchedJobs,
} = require(
    "../controllers/matchingController"
);

router.get(
    "/search",
    protect,
    getJobs
);

router.get(
    "/matches",
    protect,
    getMatchedJobs
);

module.exports =
    router;