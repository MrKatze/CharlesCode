import 'package:flutter/material.dart';
import '../../models/respuestas.dart';
import '/core/services/actividades_service.dart';

class ActividadesEstudianteScreen extends StatefulWidget {
  final int idEstudiante;
  const ActividadesEstudianteScreen({super.key, required this.idEstudiante});

  @override
  State<ActividadesEstudianteScreen> createState() =>
      _ActividadesEstudianteScreenState();
}

class _ActividadesEstudianteScreenState
    extends State<ActividadesEstudianteScreen> {
  late Future<List<RespuestaActividad>> _actividadesFuture;

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  void _cargarActividades() {
    // Asegúrate de que el idEstudiante es el del usuario logueado
    _actividadesFuture = ActividadService.obtenerRespuestasPorAlumno(
      widget.idEstudiante,
    );
  }

  Future<void> _enviarRespuesta(int idActividad, String respuesta) async {
    debugPrint(
      'Enviando respuesta para actividad $idActividad con usuario ${widget.idEstudiante}',
    );
    final exito = await ActividadService.enviarRespuesta(
      idActividad,
      widget.idEstudiante,
      respuesta,
    );
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuesta enviada exitosamente')),
      );
      setState(_cargarActividades);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar respuesta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis actividades')),
      body: FutureBuilder<List<RespuestaActividad>>(
        future: _actividadesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final actividades = snapshot.data ?? [];
          final now = DateTime.now();
          // SOLO considera contestadas las que tienen respuesta no vacía
          final contestadas =
              actividades
                  .where((a) => (a.respuesta ?? '').trim().isNotEmpty)
                  .toList();
          // No contestadas y dentro de tiempo
          final noContestadas =
              actividades.where((a) {
                final sinRespuesta = (a.respuesta ?? '').trim().isEmpty;
                final fechaEntrega = a.fechaEntrega;
                return sinRespuesta &&
                    (fechaEntrega == null || fechaEntrega.isAfter(now));
              }).toList();
          // No contestadas y fuera de tiempo
          final fueraDeTiempo =
              actividades.where((a) {
                final sinRespuesta = (a.respuesta ?? '').trim().isEmpty;
                final fechaEntrega = a.fechaEntrega;
                return sinRespuesta &&
                    (fechaEntrega != null && fechaEntrega.isBefore(now));
              }).toList();
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Actividades contestadas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...contestadas.map(
                (actividad) => Card(
                  child: ListTile(
                    title: Text(actividad.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tu respuesta: ${actividad.respuesta ?? ''}'),
                        Text(
                          'Calificación: ${actividad.calificacion?.toString() ?? 'Sin calificar'}',
                        ),
                        Text(
                          'Comentario del profesor: ${actividad.comentarioMaestro ?? 'Sin comentario'}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Actividades no contestadas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...noContestadas.map(
                (actividad) => Card(
                  child: ListTile(
                    title: Text(actividad.titulo),
                    subtitle: const Text('No has enviado respuesta'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        if ((actividad.idActividad ?? 0) != 0) {
                          _mostrarFormularioRespuesta(
                            context,
                            actividad.idActividad ?? 0,
                            actividad.titulo,
                            actividad.descripcion ?? '',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No se puede responder a esta actividad.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Actividades fuera de tiempo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              ...fueraDeTiempo.map(
                (actividad) => Card(
                  color: Colors.red.withOpacity(
                    0.15,
                  ), // Fondo oscuro/transparente para modo oscuro
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      actividad.titulo,
                      style: const TextStyle(color: Colors.red),
                    ),
                    subtitle: Text(
                      'No has enviado respuesta\nFecha límite: ${actividad.fechaEntrega != null ? actividad.fechaEntrega!.toLocal().toString().split(' ')[0] : 'Sin fecha'}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    trailing: const Icon(Icons.lock, color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarFormularioRespuesta(
    BuildContext context,
    int idActividad,
    String titulo,
    String descripcion,
  ) {
    final respuestaController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Responder: $titulo'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    descripcion,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: respuestaController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Pega tu código aquí',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final respuesta = respuestaController.text.trim();
                  if (respuesta.isNotEmpty) {
                    _enviarRespuesta(idActividad, respuesta);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La respuesta no puede estar vacía'),
                      ),
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
    );
  }
}
