import 'package:flutter/material.dart';
import '../../../models/actividad.dart';
import '../../../models/respuestas.dart';
import '/core/services/actividades_service.dart';

class DetalleActividadScreen extends StatefulWidget {
  final Actividad actividad;

  const DetalleActividadScreen({super.key, required this.actividad});

  @override
  State<DetalleActividadScreen> createState() => _DetalleActividadScreenState();
}

class _DetalleActividadScreenState extends State<DetalleActividadScreen> {
  late Future<List<RespuestaActividad>> _respuestasFuture;

  @override
  void initState() {
    super.initState();
    _cargarRespuestas();
  }

  void _cargarRespuestas() {
    _respuestasFuture = ActividadService.obtenerRespuestasPorActividad(
      widget.actividad.id!,
    );
  }

  Future<void> _calificarRespuesta(
    int? idRespuesta,
    double calificacion,
    String comentario,
  ) async {
    if (idRespuesta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede calificar una respuesta inexistente.'),
        ),
      );
      return;
    }
    final exito = await ActividadService.actualizarCalificacionRespuesta(
      idRespuesta: idRespuesta,
      calificacion: calificacion,
      comentarioMaestro: comentario,
    );

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calificación actualizada exitosamente')),
      );
      _cargarRespuestas();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar calificación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actividad: ${widget.actividad.titulo}')),
      body: FutureBuilder<List<RespuestaActividad>>(
        future: _respuestasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final respuestas = snapshot.data ?? [];
          if (respuestas.isEmpty) {
            return const Center(
              child: Text('No hay respuestas para esta actividad'),
            );
          }
          return ListView.builder(
            itemCount: respuestas.length,
            itemBuilder: (context, index) {
              final respuesta = respuestas[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text('Estudiante: ${respuesta.nombreEstudiante}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código enviado: ${respuesta.respuesta}'),
                      Text(
                        'Estado: ${respuesta.calificacion != null ? "Calificada" : "Pendiente"}',
                      ),
                      if (respuesta.calificacion != null)
                        Text('Calificación: ${respuesta.calificacion}'),
                      if (respuesta.comentarioMaestro != null)
                        Text('Comentario: ${respuesta.comentarioMaestro}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _mostrarFormularioCalificacion(context, respuesta);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarFormularioCalificacion(
    BuildContext context,
    RespuestaActividad respuesta,
  ) {
    final calificacionController = TextEditingController(
      text: respuesta.calificacion?.toString() ?? '',
    );
    final comentarioController = TextEditingController(
      text: respuesta.comentarioMaestro ?? '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Calificar Respuesta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: calificacionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calificación (0-10)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: comentarioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comentario',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final calificacion = double.tryParse(
                    calificacionController.text.trim(),
                  );
                  final comentario = comentarioController.text.trim();

                  if (calificacion != null &&
                      calificacion >= 0 &&
                      calificacion <= 10) {
                    _calificarRespuesta(respuesta.id, calificacion, comentario);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa una calificación válida (0-10)'),
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }
}
