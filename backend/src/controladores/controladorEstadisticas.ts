import { Request, Response } from 'express';
import pool from '../dataBase';

class ControladorEstadisticas {
  // Promedio de calificaciones por alumno
  public async promedioCalificacionesPorAlumno(req: Request, res: Response): Promise<void> {
    try {
      const [result]: any = await pool.query(`
        SELECT u.id_usuario, u.nombre, AVG(r.calificacion) AS promedio
        FROM usuarios u
        JOIN respuestas_actividades r ON u.id_usuario = r.id_alumno
        WHERE u.rol = 'Estudiante'
        GROUP BY u.id_usuario, u.nombre
      `);
      res.json({ success: true, data: result });
    } catch (error) {
      console.error('Error en promedioCalificacionesPorAlumno:', error);
      res.status(500).json({ success: false, message: 'Error al obtener promedios', error });
    }
  }

  // Histograma de calificaciones (conteo por rango)
  public async histogramaCalificaciones(req: Request, res: Response): Promise<void> {
    try {
      const [result]: any = await pool.query(`
        SELECT 
          CASE 
            WHEN calificacion >= 90 THEN '90-100'
            WHEN calificacion >= 80 THEN '80-89'
            WHEN calificacion >= 70 THEN '70-79'
            WHEN calificacion >= 60 THEN '60-69'
            ELSE '0-59'
          END AS rango,
          COUNT(*) AS cantidad
        FROM respuestas_actividades
        GROUP BY rango
        ORDER BY rango DESC
      `);
      res.json({ success: true, data: result });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error al obtener histograma', error });
    }
  }

  // Progreso de actividades completadas por alumno
  public async progresoPorAlumno(req: Request, res: Response): Promise<void> {
    try {
      const [result]: any = await pool.query(`
        SELECT u.id_usuario, u.nombre, COUNT(DISTINCT r.id_actividad) AS actividades_completadas
        FROM usuarios u
        LEFT JOIN respuestas_actividades r ON u.id_usuario = r.id_alumno
        WHERE u.rol = 'Estudiante'
        GROUP BY u.id_usuario, u.nombre
      `);
      res.json({ success: true, data: result });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error al obtener progreso', error });
    }
  }

  // Comparativa de desempeño entre alumnos (tabla resumen)
  public async comparativaDesempeno(req: Request, res: Response): Promise<void> {
    try {
      const [result]: any = await pool.query(`
        SELECT u.id_usuario, u.nombre, COUNT(r.id_actividad) AS total_actividades, AVG(r.calificacion) AS promedio
        FROM usuarios u
        LEFT JOIN respuestas_actividades r ON u.id_usuario = r.id_alumno
        WHERE u.rol = 'Estudiante'
        GROUP BY u.id_usuario, u.nombre
        ORDER BY promedio DESC
      `);
      res.json({ success: true, data: result });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error al obtener comparativa', error });
    }
  }
}

export const controladorEstadisticas = new ControladorEstadisticas();
