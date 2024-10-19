const express = require('express');
const { signup } = require('../controller/userController'); // Adjust the path as needed

const router = express.Router();

router.post('/signup', signup);

module.exports = router;
