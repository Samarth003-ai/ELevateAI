const express =
    require("express");

const router =
    express.Router();

const protect =
    require("../middleware/authMiddleware");

const {

    saveJob,

    getSavedJobs,

    deleteSavedJob,

} = require(
    "../controllers/savedJobController"
);

router.post(
    "/",
    protect,
    saveJob,
);

router.get(
    "/",
    protect,
    getSavedJobs,
);

router.delete(
    "/:id",
    protect,
    deleteSavedJob,
);

module.exports =
    router;