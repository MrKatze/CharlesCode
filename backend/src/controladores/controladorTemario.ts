import { Request, Response } from 'express';
import pool from '../dataBase';

class ControladorTemario {
  public async obtenerLenguajeYTemario(req: Request, res: Response): Promise<void> {
    try {
      const { nombre } = req.params;
      console.log('Lenguaje recibido:', nombre);
      const query = `
        SELECT l.descripcion, t.tema
        FROM lenguajes l
        JOIN temario t ON l.id = t.lenguaje_id
        WHERE l.nombre = ?
        ORDER BY t.id
      `;

      const [result]: any = await pool.query(query, [nombre]);

      if (result.length === 0) {
        res.status(404).json({
          success: false,
          statusCode: 404,
          message: 'Lenguaje no encontrado',
          data: null
        });
        return;
      }

      const descripcion = result[0].descripcion;
      const temario = result.map((row: any) => row.tema);

      // Respuesta solo con los parámetros que pediste
      res.status(200).json({
        descripcion,
        temario
      });
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({
        success: false,
        statusCode: 500,
        message: 'Error al ejecutar consulta',
        data: null
      });
    }
  }
}

export const controladorTemario = new ControladorTemario();
