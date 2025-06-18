import 'package:flutter/material.dart';
import 'registro_controller.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistroController(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Registro de Usuario')),
        body: Consumer<RegistroController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: controller.usuarioController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: controller.correoController,
                    decoration: const InputDecoration(labelText: 'Correo'),
                  ),
                  TextField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: controller.rolController,
                    decoration: const InputDecoration(
                      labelText: 'Rol (opcional)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  controller.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () async {
                          final exito = await controller.registrarUsuario();
                          final snackBar = SnackBar(
                            content: Text(
                              exito
                                  ? 'Registro exitoso'
                                  : 'Error en el registro',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          if (exito) Navigator.pop(context);
                        },
                        child: const Text('Registrarse'),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
