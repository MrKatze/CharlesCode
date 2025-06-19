import 'package:flutter/material.dart';
import '../../../models/actividad.dart';
import '../../../models/usuario.dart';
import '/core/services/actividades_service.dart';
import 'crear_actividad_screen.dart';

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
    _actividadesFuture = ActividadService.obtenerActividadesPorMaestro(widget.maestro.idUsuario);
  }

  Future<void> _refrescar() async {
    setState(() {
      _cargarActividades();
    });
  }

  void _irCrearActividad() async {
    // Navega a crear actividad, y al volver refresca la lista
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearActividadScreen(maestro: widget.maestro),
      ),
    );
    _refrescar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades de ${widget.maestro.nombre}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irCrearActividad,
        child: const Icon(Icons.add),
        tooltip: 'Crear nueva actividad',
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
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(actividad.titulo),
                    subtitle: Text('Entrega: ${actividad.fechaEntrega ?? "Sin fecha"}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Aquí podrías navegar a pantalla de detalles o edición
                    },
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
