import express, { Application } from 'express';
import morgan from 'morgan';
import cors from 'cors';

import usuariosRutas from './rutas/rutaUsuario';  // Asegúrate de que la ruta sea correcta
import rutasTemario from './rutas/rutaTemario';
import actividadesRoutes from './rutas/rutasActividades';
import rutaEstadisticas from './rutas/rutaEstadisticas'; // <-- Agregar import de estadísticas

const app: Application = express();

// Configuración de middlewares
app.use(morgan('dev'));
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Montaje de rutas
app.use('/api/usuarios', usuariosRutas);
app.use('/api/temas', rutasTemario);
app.use('/api/actividades', actividadesRoutes);
app.use('/api/estadisticas', rutaEstadisticas); // <-- Agregar ruta de estadísticas

// Exportamos la app sin levantar el servidor (ideal para pruebas)
export default app;
