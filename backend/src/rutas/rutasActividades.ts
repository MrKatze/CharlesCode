import { Router } from 'express';
import { controladorActividades } from '../controladores/controladorActividades';

const router = Router();

router.post('/agregar', controladorActividades.agregarActividad);
router.get('/', controladorActividades.obtenerActividades);
router.get('/maestro/:id_maestro', controladorActividades.obtenerActividadesPorMaestro);
router.post('/respuestas', controladorActividades.responderActividad);
router.get('/respuestas/:id_alumno', controladorActividades.obtenerRespuestasPorAlumno);
router.put('/respuestas/:id/calificar', controladorActividades.calificarRespuesta);
router.put('/actividades/:id', controladorActividades.modificarActividad);

export default router;
