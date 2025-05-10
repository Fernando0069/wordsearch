const { User } = require('../models');
const jwt = require('jsonwebtoken');

const register = async (req, res) => {
  try {
    const { username, email, password, interface_language = 'en', words_language = 'en' } = req.body;

    // Verifica si el usuario ya existe
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'El email ya está registrado' });
    }

    // Crea nuevo usuario con idiomas
    const newUser = await User.create({
      username,
      email,
      password,
      interface_language,
      words_language
    });

    return res.status(201).json({
      message: 'Usuario creado correctamente',
      user: {
        id: newUser.id,
        username: newUser.username,
        email: newUser.email,
        interface_language: newUser.interface_language,
        words_language: newUser.words_language
      }
    });
  } catch (error) {
    console.error('Error en el registro:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Busca el usuario
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // Valida la contraseña
    const isValid = await user.validPassword(password);
    if (!isValid) {
      return res.status(401).json({ message: 'Contraseña incorrecta' });
    }

    // Crea el token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        interface_language: user.interface_language,
        words_language: user.words_language
      }
    });
  } catch (error) {
    console.error('Error en el login:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

const getProfile = async (req, res) => {
  try {
    const user = await User.findByPk(req.userId, {
      attributes: ['id', 'username', 'email', 'interface_language', 'words_language']
    });

    if (!user) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    res.json(user);
  } catch (error) {
    console.error('Error al obtener perfil:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

module.exports = {
  register,
  login,
  getProfile
};
