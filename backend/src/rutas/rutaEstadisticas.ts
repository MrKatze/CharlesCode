import { Router } from 'express';
import { controladorEstadisticas } from '../controladores/controladorEstadisticas';

class RutaEstadisticas {
  public router: Router = Router();
  constructor() {
    this.config();
  }
  config(): void {
    this.router.get('/promedio-alumnos', controladorEstadisticas.promedioCalificacionesPorAlumno);
    this.router.get('/histograma', controladorEstadisticas.histogramaCalificaciones);
    this.router.get('/progreso', controladorEstadisticas.progresoPorAlumno);
    this.router.get('/comparativa', controladorEstadisticas.comparativaDesempeno);
  }
}

const rutaEstadisticas = new RutaEstadisticas();
export default rutaEstadisticas.router;
