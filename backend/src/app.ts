import express, { Application } from 'express';
import morgan from 'morgan';
import cors from 'cors';

import usuariosRutas from './rutas/rutaUsuario';  // Asegúrate de que la ruta sea correcta

// Importar todas tus rutas

const app: Application = express();

// Configuración de middlewares
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Montaje de rutas
app.use('/api/usuarios', usuariosRutas);

// Exportamos la app sin levantar el servidor (ideal para pruebas)
export default app;
