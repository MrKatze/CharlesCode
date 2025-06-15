import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../models/usuario.dart';

class LoginController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;
  String? _error;
  Usuario? _usuario;

  bool get loading => _loading;
  String? get error => _error;
  Usuario? get usuario => _usuario;

  Future<bool> login() async {
    _setLoading(true);
    _error = null;

    final user = await _authService.login(
      usuarioController.text.trim(),
      passwordController.text.trim(),
    );

    _setLoading(false);

    if (user != null) {
      _usuario = user;
      notifyListeners();
      return true;
    } else {
      _error = 'Usuario o contraseña incorrectos';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}