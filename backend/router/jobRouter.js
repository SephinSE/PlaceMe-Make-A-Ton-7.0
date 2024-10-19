const express = require("express");
const { createJobDetails } = require("../controller/jobController");
const { checkRole, authenticateJWT } = require("../middleware/auth");
const router = express.Router();

router.post("/create",authenticateJWT,checkRole(true), createJobDetails);

module.exports = router;