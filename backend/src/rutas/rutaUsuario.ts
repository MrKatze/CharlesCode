import { Router } from 'express';
import { controladorUsuarios } from '../controladores/controladorUsuario';

class RutasUsuario
{
    public router: Router=Router();
    constructor()
    {
        this.config();
    }
    config() : void
    {
       // this.router.get('/', controladorUsuarios.mostrarUsuarios);
        this.router.get('/:id', controladorUsuarios.mostrarUnUsuario);
        this.router.post('/agregar', controladorUsuarios.agregarUsuario);
        this.router.put('/modificar/:id', controladorUsuarios.modificarUsuario);
        this.router.delete('/:id', controladorUsuarios.eliminarUsuario);
        this.router.post('/login', controladorUsuarios.login);
        this.router.get('/', controladorUsuarios.mostrarEstudiantes);
    }
}
const rutasUsuario= new RutasUsuario();
export default rutasUsuario.router;