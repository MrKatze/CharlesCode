import { Router } from 'express';
import { controladorActividades } from '../controladores/controladorActividades';

const router = Router();

// Agregar actividad
router.post('/agregar', controladorActividades.agregarActividad);
// Obtener todas las actividades
router.get('/', controladorActividades.obtenerActividades);
// Obtener actividades por maestro
router.get('/maestro/:id_maestro', controladorActividades.obtenerActividadesPorMaestro);
// Detalle de actividades de un estudiante (contestadas y no contestadas)
router.get('/detalle-estudiante/:id_estudiante', controladorActividades.detalleActividadesEstudiante);
// Enviar respuesta de estudiante
router.post('/respuestas', controladorActividades.enviarRespuesta);
// Calificar respuesta (profesor)
router.put('/respuestas/:id/calificar', controladorActividades.calificarRespuesta);
// Obtener actividades y respuestas de un alumno (para el alumno)
router.get('/respuestas/:id_alumno', controladorActividades.obtenerRespuestasPorAlumno);
// Modificar actividad
router.put('/actividades/:id', controladorActividades.modificarActividad);
// Enviar respuesta (PUT)
router.put('/respuestas/enviar', controladorActividades.enviarRespuesta);

export default router;
