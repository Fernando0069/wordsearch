const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');

// Ruta para registrar un nuevo usuario
router.post('/register', UserController.register);

// Ruta para hacer login
router.post('/login', UserController.login);

module.exports = router;
