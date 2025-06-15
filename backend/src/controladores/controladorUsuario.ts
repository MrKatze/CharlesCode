import { Request, Response } from 'express';
import pool from '../dataBase';

class ControladorUsuarios {
  public async mostrarUsuarios(req: Request, res: Response): Promise<void> {
    try {
      const [usuarios]: any = await pool.query('SELECT * FROM usuarios');
      res.status(200).json({
        success: true,
        statusCode: 200,
        message: usuarios.length > 0 ? 'Usuarios encontrados' : 'No hay usuarios',
        data: usuarios
      });
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }

  public async mostrarUnUsuario(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const [usuario]: any = await pool.query('SELECT * FROM usuarios WHERE id_usuario = ?', [id]);

      if (usuario.length > 0) {
        res.status(200).json({ success: true, statusCode: 200, message: 'Usuario encontrado', data: usuario[0] });
      } else {
        res.status(404).json({ success: false, statusCode: 404, message: 'Usuario no encontrado', data: null });
      }
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }

  public async eliminarUsuario(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const [resultado]: any = await pool.query('DELETE FROM usuarios WHERE id_usuario = ?', [id]);

      if (resultado.affectedRows > 0) {
        res.status(200).json({ success: true, statusCode: 200, message: 'Usuario eliminado correctamente', data: { deletedRows: resultado.affectedRows } });
      } else {
        res.status(404).json({ success: false, statusCode: 404, message: 'Usuario no encontrado', data: { deletedRows: 0 } });
      }
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }

  public async agregarUsuario(req: Request, res: Response): Promise<void> {
    try {
      const { nombre, usuario, correo, password, rol } = req.body;
      const nuevoUsuario = { nombre, usuario, correo, password, rol };

      const [resultado]: any = await pool.query('INSERT INTO usuarios SET ?', [nuevoUsuario]);

      res.status(201).json({
        success: true,
        statusCode: 201,
        message: 'Usuario agregado correctamente',
        data: { id: resultado.insertId }
      });
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }

  public async modificarUsuario(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { nombre, usuario, correo, password, rol } = req.body;
      const datosActualizados = { nombre, usuario, correo, password, rol };

      const [resultado]: any = await pool.query('UPDATE usuarios SET ? WHERE id_usuario = ?', [datosActualizados, id]);

      res.status(200).json({
        success: true,
        statusCode: 200,
        message: 'Usuario actualizado correctamente',
        data: { updatedRows: resultado.affectedRows }
      });
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }

  public async login(req: Request, res: Response): Promise<void> {
    try {
      const { usuario, password } = req.body;
      const [resultado]: any = await pool.query(
        'SELECT * FROM usuarios WHERE usuario = ? AND password = ?', [usuario, password]
      );

      if (resultado.length > 0) {
        res.status(200).json({
          success: true,
          statusCode: 200,
          message: 'Inicio de sesión exitoso',
          data: resultado[0]
        });
      } else {
        res.status(401).json({
          success: false,
          statusCode: 401,
          message: 'Usuario o contraseña incorrectos',
          data: null
        });
      }
    } catch (error) {
      console.error('Error al ejecutar consulta:', error);
      res.status(500).json({ success: false, statusCode: 500, message: 'Error al ejecutar consulta', data: null });
    }
  }
}

export const controladorUsuarios = new ControladorUsuarios();
