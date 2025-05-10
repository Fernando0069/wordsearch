require('dotenv').config();
const express = require('express');
const app = express();
const { sequelize } = require('./config/database');
const routes = require('./routes'); // Esto carga src/routes/index.js

app.use(express.json());

// Rutas principal "/"
app.get('/', (req, res) => {
  res.send('API running');
});

// Rutas agrupadas (por ejemplo, /api/users/register)
app.use('/api', routes);

const PORT = process.env.PORT || 3000;

sequelize.authenticate()
  .then(() => {
    console.log('Conexión a la base de datos exitosa.');
    return sequelize.sync(); // crea tablas si no existen
  })
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Servidor escuchando en el puerto ${PORT}`);
    });
  })
  .catch(err => {
    console.error('Error al conectar a la base de datos:', err);
  });
