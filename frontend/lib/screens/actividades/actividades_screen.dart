import 'package:flutter/material.dart';
import '../../../models/actividad.dart';
import '../../../models/usuario.dart';
import '/core/services/actividades_service.dart';
import '../../screens/actividades/crear_actividad.dart';

class ActividadesScreen extends StatefulWidget {
  final Usuario maestro;

  const ActividadesScreen({super.key, required this.maestro});

  @override
  State<ActividadesScreen> createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  late Future<List<Actividad>> _actividadesFuture;

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  void _cargarActividades() {
    _actividadesFuture = ActividadService.obtenerActividadesPorMaestro(
      widget.maestro.idUsuario,
    );
  }

  Future<void> _refrescar() async {
    setState(() {
      _cargarActividades();
    });
  }

  void _irCrearActividad() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearActividadScreen(maestro: widget.maestro),
      ),
    );
    _refrescar();
  }

  void _editarActividad(BuildContext context, Actividad actividad) {
    final tituloController = TextEditingController(text: actividad.titulo);
    final descripcionController = TextEditingController(
      text: actividad.descripcion,
    );
    final fechaEntregaController = TextEditingController(
      text: actividad.fechaEntrega ?? '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Editar Actividad'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: fechaEntregaController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de entrega (YYYY-MM-DD)',
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
                onPressed: () async {
                  final titulo = tituloController.text.trim();
                  final descripcion = descripcionController.text.trim();
                  final fechaEntrega = fechaEntregaController.text.trim();

                  if (titulo.isEmpty || descripcion.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Título y descripción son obligatorios'),
                      ),
                    );
                    return;
                  }

                  final actividadModificada = Actividad(
                    id: actividad.id,
                    titulo: titulo,
                    descripcion: descripcion,
                    fechaEntrega: fechaEntrega.isEmpty ? null : fechaEntrega,
                    idMaestro: actividad.idMaestro,
                    idLenguaje: actividad.idLenguaje,
                  );

                  final exito = await ActividadService.modificarActividad(
                    actividadModificada,
                  );

                  if (exito) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Actividad actualizada con éxito'),
                      ),
                    );
                    _refrescar();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar la actividad'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Actividades de ${widget.maestro.nombre}')),
      floatingActionButton: FloatingActionButton(
        onPressed: _irCrearActividad,
        tooltip: 'Crear nueva actividad',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Actividad>>(
        future: _actividadesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final actividades = snapshot.data ?? [];
          if (actividades.isEmpty) {
            return const Center(child: Text('No hay actividades creadas'));
          }
          return RefreshIndicator(
            onRefresh: _refrescar,
            child: ListView.builder(
              itemCount: actividades.length,
              itemBuilder: (context, index) {
                final actividad = actividades[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    title: Text(actividad.titulo),
                    subtitle: Text(
                      'Entrega: ${actividad.fechaEntrega ?? "Sin fecha"}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _editarActividad(context, actividad),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
