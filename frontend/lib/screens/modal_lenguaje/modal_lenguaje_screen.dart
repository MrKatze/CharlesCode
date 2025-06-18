import 'package:flutter/material.dart';
import '../../core/services/temario_service.dart';  // Ajusta la ruta
import '../../models//temario.dart';    // Ajusta la ruta

void mostrarInfoLenguajeModal(BuildContext context, String nameLenguaje) {
  final servicio = LenguajeService();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FutureBuilder<LenguajeTemario?>(
        future: servicio.obtenerLenguajeTemario(nameLenguaje),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No se pudo cargar la información del lenguaje.',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          final LenguajeTemario lenguajeData = snapshot.data!;

          return FractionallySizedBox(
            heightFactor: 0.95,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nameLenguaje,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lenguajeData.descripcion,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Temario:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: lenguajeData.temario.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.check_circle_outline, color: Colors.white),
                        title: Text(
                          lenguajeData.temario[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
