const express = require('express');
const router = express.Router();

const userRoutes = require('./userRoutes'); // ✅ Añadir esto

router.use('/users', userRoutes); // ✅ Añadir esto

router.get('/', (req, res) => {
  res.send('API de Word Search en funcionamiento');
});

module.exports = router;
