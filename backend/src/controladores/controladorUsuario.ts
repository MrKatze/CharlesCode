import { Request, Response } from 'express';
import pool from '../dataBase';

class ControladorUsuarios {
    /**
     * Obtener todos los usuarios
     */
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
            res.status(500).json({
                success: false,
                statusCode: 500,
                message: 'Error al ejecutar consulta',
                data: null
            });
        }
    }

    /**
     * Obtener un solo usuario por ID
     */
    public async mostrarUnUsuario(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const [usuario]: any = await pool.query('SELECT * FROM usuarios WHERE id_usuario = ?', [id]);

            if (usuario.length > 0) {
                res.status(200).json({
                    success: true,
                    statusCode: 200,
                    message: 'Usuario encontrado',
                    data: usuario[0]
                });
            } else {
                res.status(404).json({
                    success: false,
                    statusCode: 404,
                    message: 'Usuario no encontrado',
                    data: null
                });
            }
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

    /**
     * Eliminar un usuario por ID
     */
    public async eliminarUsuario(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const [resultado]: any = await pool.query('DELETE FROM usuarios WHERE id_usuario = ?', [id]);

            if (resultado.affectedRows > 0) {
                res.status(200).json({
                    success: true,
                    statusCode: 200,
                    message: 'Usuario eliminado correctamente',
                    data: { deletedRows: resultado.affectedRows }
                });
            } else {
                res.status(404).json({
                    success: false,
                    statusCode: 404,
                    message: 'Usuario no encontrado, no se eliminó nada',
                    data: { deletedRows: 0 }
                });
            }
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

    /**
     * Agregar nuevo usuario
     */
    public async agregarUsuario(req: Request, res: Response): Promise<void> {
        try {
            const nuevoUsuario = req.body;
            const [resultado]: any = await pool.query('INSERT INTO usuarios SET ?', [nuevoUsuario]);

            res.status(201).json({
                success: true,
                statusCode: 201,
                message: 'Usuario agregado correctamente',
                data: { id: resultado.insertId }
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

    /**
     * Modificar usuario por ID
     */
    public async modificarUsuario(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const datosActualizados = req.body;
            const [resultado]: any = await pool.query('UPDATE usuarios SET ? WHERE id_usuario = ?', [datosActualizados, id]);

            res.status(200).json({
                success: true,
                statusCode: 200,
                message: 'Usuario actualizado correctamente',
                data: { updatedRows: resultado.affectedRows }
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

    /**
     * Login de usuario por nombre de usuario y contraseña
     */
    public async login(req: Request, res: Response): Promise<void> {
        try {
            const { usuario, password } = req.body;
            const [resultado]: any = await pool.query('SELECT * FROM usuarios WHERE usuario = ? AND password = ?', [usuario, password]);

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
            res.status(500).json({
                success: false,
                statusCode: 500,
                message: 'Error al ejecutar consulta',
                data: null
            });
        }
    }
}

export const controladorUsuarios = new ControladorUsuarios();
