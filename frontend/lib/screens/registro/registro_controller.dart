import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '../../../core/services/usuario_services.dart';

class RegistroController extends ChangeNotifier {
  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final rolController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> registrarUsuario() async {
    _isLoading = true;
    notifyListeners();
    final usuario = Usuario(
      idUsuario: 0,
      nombre: nombreController.text,
      usuario: usuarioController.text,
      correo: correoController.text,
      password: passwordController.text,
      rol: rolController.text.isNotEmpty ? rolController.text : 'usuario',
    );
    final exito = await UsuarioServices.registrarUsuario(usuario);
    _isLoading = false;
    notifyListeners();
    return exito;
  }

  @override
  void dispose() {
    nombreController.dispose();
    usuarioController.dispose();
    correoController.dispose();
    passwordController.dispose();
    rolController.dispose();
    super.dispose();
  }
}
