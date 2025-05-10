const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');
const authenticateToken = require('../middleware/authMiddleware');

// Ruta para registrar un nuevo usuario
router.post('/register', UserController.register);

// Ruta para hacer login
router.post('/login', UserController.login);

// Ruta protegida: obtener datos del usuario autenticado
router.get('/me', authenticateToken, UserController.getProfile);

module.exports = router;
