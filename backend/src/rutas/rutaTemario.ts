import { Router } from 'express';
import { controladorTemario } from '../controladores/controladorTemario';

class RutasTemario {
  public router: Router = Router();

  constructor() {
    this.config();
  }

  config(): void {
    // Ruta para obtener descripción + temario por nombre de lenguaje
    this.router.get('/:nombre', controladorTemario.obtenerLenguajeYTemario);
  }
}

const rutasTemario = new RutasTemario();
export default rutasTemario.router;
