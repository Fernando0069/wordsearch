require('dotenv').config();
const express = require('express');
const app = express();
const { sequelize } = require('./config/database');
const routes = require('./routes');

app.use(express.json());
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



const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes');
require('dotenv').config();

// Middlewares
app.use(express.json());

// Rutas
app.use('/api/users', userRoutes);

// Puerto y escucha
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor API escuchando en el puerto ${PORT}`);
});
