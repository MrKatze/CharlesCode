import { Request, Response } from 'express';
import pool from '../dataBase';

class ControladorActividades {
  public async agregarActividad(req: Request, res: Response): Promise<void> {
    try {
      const { titulo, descripcion, fecha_entrega, id_maestro, id_lenguaje } = req.body;

      // Validación rápida (opcional pero recomendable)
      if (!titulo || !descripcion || !id_maestro || !id_lenguaje) {
        res.status(400).json({
          success: false,
          statusCode: 400,
          message: 'Faltan campos obligatorios',
          data: null
        });
        return;
      }

      const nuevaActividad = {
        titulo,
        descripcion,
        fecha_entrega: fecha_entrega || null,
        id_maestro,
        id_lenguaje
      };

      const [resultado]: any = await pool.query('INSERT INTO actividades SET ?', [nuevaActividad]);

      const actividadId = resultado.insertId;

      // Asignar la actividad a todos los estudiantes
      const [estudiantes]: any = await pool.query('SELECT id_usuario FROM usuarios WHERE rol = "Estudiante"');

      if (estudiantes.length > 0) {
        const asignaciones = estudiantes.map((estudiante: any) => [actividadId, estudiante.id_usuario, '']);
        await pool.query(
          'INSERT INTO respuestas_actividades (id_actividad, id_alumno, respuesta) VALUES ?',
          [asignaciones]
        );
      }

      res.status(201).json({
        success: true,
        statusCode: 201,
        message: 'Actividad registrada y asignada a estudiantes correctamente',
        data: { id: actividadId }
      });
    } catch (error) {
      console.error('Error al agregar actividad:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error interno al agregar actividad',
        data: null
      });
    }
  }

  public async obtenerActividades(req: Request, res: Response): Promise<void> {
    try {
      const [actividades]: any = await pool.query('SELECT * FROM actividades');
      res.status(200).json({
        success: true,
        statusCode: 200,
        message: 'Actividades obtenidas',
        data: actividades
      });
    } catch (error) {
      console.error('Error al obtener actividades:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error al obtener actividades',
        data: null
      });
    }
  }

  public async obtenerActividadesPorMaestro(req: Request, res: Response): Promise<void> {
    try {
      const { id_maestro } = req.params;

      const [actividades]: any = await pool.query(
        'SELECT * FROM actividades WHERE id_maestro = ?',
        [id_maestro]
      );

      res.status(200).json({
        success: true,
        statusCode: 200,
        message: actividades.length > 0 ? 'Actividades encontradas' : 'No hay actividades para este maestro',
        data: actividades
      });
    } catch (error) {
      console.error('Error al obtener actividades del maestro:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error al obtener actividades',
        data: null
      });
    }
  }

  public async modificarActividad(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { titulo, descripcion, fecha_entrega, id_maestro, id_lenguaje } = req.body;

      // Validación rápida
      if (!titulo || !descripcion || !id_maestro || !id_lenguaje) {
        res.status(400).json({
          success: false,
          statusCode: 400,
          message: 'Faltan campos obligatorios',
          data: null
        });
        return;
      }

      const [resultado]: any = await pool.query(
        `UPDATE actividades 
         SET titulo = ?, descripcion = ?, fecha_entrega = ?, id_maestro = ?, id_lenguaje = ?
         WHERE id = ?`,
        [titulo, descripcion, fecha_entrega || null, id_maestro, id_lenguaje, id]
      );

      if (resultado.affectedRows > 0) {
        res.status(200).json({
          success: true,
          statusCode: 200,
          message: 'Actividad actualizada correctamente',
          data: { id }
        });
      } else {
        res.status(404).json({
          success: false,
          statusCode: 404,
          message: 'No se encontró la actividad para actualizar',
          data: null
        });
      }
    } catch (error) {
      console.error('Error al modificar actividad:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error interno al modificar la actividad',
        data: null
      });
    }
  }

  public async obtenerRespuestasPorActividad(req: Request, res: Response): Promise<void> {
    try {
      const { id_actividad } = req.params;

      const [respuestas]: any = await pool.query(
        `SELECT ar.*, u.nombre AS nombreEstudiante
         FROM actividades_respuestas ar
         INNER JOIN usuarios u ON ar.id_estudiante = u.id_usuario
         WHERE ar.id_actividad = ?`,
        [id_actividad]
      );

      res.status(200).json({
        success: true,
        statusCode: 200,
        message: respuestas.length > 0 ? 'Respuestas encontradas' : 'No hay respuestas para esta actividad',
        data: respuestas
      });
    } catch (error) {
      console.error('Error al obtener respuestas por actividad:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error interno al obtener respuestas por actividad',
        data: null
      });
    }
  }

  public async enviarRespuesta(req: Request, res: Response): Promise<void> {
    try {
      const { id_actividad, id_alumno, respuesta } = req.body;
      if (!id_actividad || !id_alumno || !respuesta) {
        res.status(400).json({ success: false, statusCode: 400, message: 'Faltan campos obligatorios', data: null });
        return;
      }
      // UPDATE para modificar la tupla existente
      const [resultado]: any = await pool.query(
        'UPDATE respuestas_actividades SET respuesta = ?, fecha_respuesta = CURRENT_TIMESTAMP WHERE id_actividad = ? AND id_alumno = ?',
        [respuesta, id_actividad, id_alumno]
      );
      // Siempre responde 200 aunque affectedRows sea 0 (por si la respuesta es igual a la anterior)
      res.status(200).json({ success: true, statusCode: 200, message: 'Respuesta actualizada correctamente', data: null });
    } catch (error) {
      console.error('Error al enviar respuesta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error interno al enviar respuesta', data: null });
    }
  }

  public async detalleActividadesEstudiante(req: Request, res: Response): Promise<void> {
    try {
      const { id_estudiante } = req.params;
      // Todas las actividades asignadas
      const [actividades]: any = await pool.query('SELECT * FROM actividades');
      // Respuestas del estudiante
      const [respuestas]: any = await pool.query(
        'SELECT * FROM respuestas_actividades WHERE id_alumno = ?',
        [id_estudiante]
      );
      // Separar contestadas y no contestadas (solo si respuesta no es vacía)
      const contestadas = actividades.filter((a: any) => {
        const resp = respuestas.find((r: any) => r.id_actividad === a.id);
        return resp && resp.respuesta && resp.respuesta.trim() !== '';
      });
      const noContestadas = actividades.filter((a: any) => {
        const resp = respuestas.find((r: any) => r.id_actividad === a.id);
        return !resp || !resp.respuesta || resp.respuesta.trim() === '';
      });
      // Adjuntar respuesta, calificación y comentario a las contestadas
      const contestadasConDetalle = contestadas.map((a: any) => {
        const resp = respuestas.find((r: any) => r.id_actividad === a.id);
        return { ...a, respuesta: resp.respuesta, calificacion: resp.calificacion, comentario_maestro: resp.comentario_maestro, id_respuesta: resp.id };
      });
      res.status(200).json({
        success: true,
        statusCode: 200,
        message: 'Detalle de actividades del estudiante',
        data: {
          contestadas: contestadasConDetalle,
          noContestadas
        }
      });
    } catch (error) {
      console.error('Error en detalleActividadesEstudiante:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error interno', data: null });
    }
  }

  public async calificarRespuesta(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params; // id de la respuesta
      const { calificacion, comentario_maestro } = req.body;
      await pool.query(
        'UPDATE respuestas_actividades SET calificacion = ?, comentario_maestro = ? WHERE id = ?',
        [calificacion, comentario_maestro, id]
      );
      res.status(200).json({ success: true, statusCode: 200, message: 'Respuesta calificada', data: null });
    } catch (error) {
      console.error('Error al calificar respuesta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error interno al calificar', data: null });
    }
  }

  public async obtenerRespuestasPorAlumno(req: Request, res: Response): Promise<void> {
    try {
      const { id_alumno } = req.params;
      // LEFT JOIN para obtener todas las actividades y la respuesta si existe
      const [actividades]: any = await pool.query(`
        SELECT a.id AS id_actividad, a.titulo, a.descripcion, a.fecha_entrega, 
               ra.id AS id, ra.id_alumno, ra.respuesta, ra.calificacion, ra.comentario_maestro, ra.fecha_respuesta
        FROM actividades a
        LEFT JOIN respuestas_actividades ra
          ON a.id = ra.id_actividad AND ra.id_alumno = ?
      `, [id_alumno]);
      // Mapear para que los campos nunca sean null (si no hay respuesta, poner valores por defecto)
      const resultado = actividades.map((a: any) => ({
        id: a.id ?? null,
        id_actividad: a.id_actividad ?? a.id ?? 0,
        id_alumno: parseInt(id_alumno), // SIEMPRE el id del alumno que consulta
        respuesta: a.respuesta ?? '',
        calificacion: a.calificacion !== null ? a.calificacion : null,
        comentario_maestro: a.comentario_maestro ?? null,
        fecha_respuesta: a.fecha_respuesta ?? null,
        titulo: a.titulo ?? '',
        descripcion: a.descripcion ?? '',
        fecha_entrega: a.fecha_entrega ?? null,
        nombre_estudiante: null
      }));
      res.status(200).json({ success: true, statusCode: 200, message: 'Actividades del alumno', data: resultado });
    } catch (error) {
      console.error('Error al obtener actividades del alumno:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error interno', data: null });
    }
  }
}

export const controladorActividades = new ControladorActividades();
