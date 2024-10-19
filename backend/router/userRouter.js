const express = require('express');
const { signup, login, updateUserProfile } = require('../controller/userController'); // Adjust the path as needed
const upload = require('../config/multerConfig');
const { authenticateJWT } = require('../middleware/auth');

const router = express.Router();

router.post('/signup', signup);
router.post('/login', login);
router.put('/:userId', upload.single('resume'),authenticateJWT, updateUserProfile);

module.exports = router;
