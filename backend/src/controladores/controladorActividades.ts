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

      res.status(201).json({
        success: true,
        statusCode: 201,
        message: 'Actividad registrada correctamente',
        data: { id: resultado.insertId }
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

  public async responderActividad(req: Request, res: Response): Promise<void> {
  try {
    const { id_actividad, id_alumno, respuesta } = req.body;

    if (!id_actividad || !id_alumno || !respuesta) {
      res.status(400).json({
        success: false,
        statusCode: 400,
        message: 'Faltan campos obligatorios',
        data: null
      });
      return;
    }

    const nuevaRespuesta = {
      id_actividad,
      id_alumno,
      respuesta
    };

    const [resultado]: any = await pool.query('INSERT INTO respuestas_actividades SET ?', [nuevaRespuesta]);

    res.status(201).json({
      success: true,
      statusCode: 201,
      message: 'Respuesta registrada correctamente',
      data: { id: resultado.insertId }
    });
  } catch (error) {
    console.error('Error al registrar respuesta:', error);
    res.status(500).json({
      success: false,
      statusCode: 500,
      message: 'Error interno al registrar la respuesta',
      data: null
    });
  }
}

public async obtenerRespuestasPorAlumno(req: Request, res: Response): Promise<void> {
  try {
    const { id_alumno } = req.params;


    // Traemos las respuestas junto con el título y la descripción de la actividad
    const [respuestas]: any = await pool.query(
      `SELECT r.*, a.titulo, a.descripcion, a.fecha_entrega
       FROM respuestas_actividades r
       INNER JOIN actividades a ON r.id_actividad = a.id
       WHERE r.id_alumno = ?`,
      [id_alumno]
    );

    res.status(200).json({
      success: true,
      statusCode: 200,
      message: respuestas.length > 0 ? 'Respuestas encontradas' : 'No hay respuestas registradas para este alumno',
      data: respuestas
    });
  } catch (error) {
    console.error('Error al obtener respuestas del alumno:', error);
    res.status(500).json({
      success: false,
      statusCode: 500,
      message: 'Error al obtener respuestas',
      data: null
    });
  }
}

public async calificarRespuesta(req: Request, res: Response): Promise<void> {
  try {
    const { id } = req.params; // id de la respuesta
    const { calificacion, comentario_maestro } = req.body;

    // Validar que calificacion sea número entre 0 y 10 si quieres validar

    const [result] = await pool.query(
      `UPDATE respuestas_actividades
       SET calificacion = ?, comentario_maestro = ?
       WHERE id = ?`,
      [calificacion, comentario_maestro, id]
    );

    if ((result as any).affectedRows > 0) {
      res.status(200).json({
        success: true,
        message: 'Calificación y comentario actualizados correctamente',
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'No se encontró la respuesta para actualizar',
      });
    }
  } catch (error) {
    console.error('Error al actualizar calificación:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno al actualizar la calificación',
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


}

export const controladorActividades = new ControladorActividades();
