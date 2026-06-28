const express = require("express");

const router = express.Router();

const protect = require("../middleware/authMiddleware");

const { chat, streamChat } = require("../controllers/chatController");

router.post("/", protect, chat);
router.post("/stream", protect, streamChat);
module.exports = router;