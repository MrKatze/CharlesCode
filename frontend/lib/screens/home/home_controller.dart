import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {
  // Aquí podrás manejar estado o lógica más adelante

  String mensajeBienvenida(String nombre) {
    return '¡Bienvenido, $nombre!';
  }
}