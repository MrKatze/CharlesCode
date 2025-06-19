import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/usuario.dart';
import '../../../models/respuestas.dart'; // importa tu modelo
import '../../core/services/actividades_service.dart';  // importa tu servicio

class DetalleEstudianteScreen extends StatefulWidget {
  final Usuario estudiante;

  const DetalleEstudianteScreen({super.key, required this.estudiante});

  @override
  State<DetalleEstudianteScreen> createState() => _DetalleEstudianteScreenState();
}

class _DetalleEstudianteScreenState extends State<DetalleEstudianteScreen> {
  List<RespuestaActividad> respuestas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarRespuestas();
  }

  Future<void> _cargarRespuestas() async {
    try {
      final data = await ActividadService.obtenerRespuestasPorAlumno(widget.estudiante.idUsuario);
      setState(() {
        respuestas = data;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar respuestas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progreso de ${widget.estudiante.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(widget.estudiante.nombre),
                      subtitle: const Text('Alumno de programación'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Actividades calificadas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: respuestas.length,
                      itemBuilder: (context, index) {
                        final actividad = respuestas[index];
                        final fechaEntrega = actividad.fechaEntrega ?? DateTime.now();
                        final fechaRespuesta = actividad.fechaRespuesta;
                        final bool aTiempo = fechaRespuesta.isBefore(fechaEntrega) || fechaRespuesta.isAtSameMomentAs(fechaEntrega);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: aTiempo ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.assignment),
                            title: Text(actividad.titulo),
                            subtitle: Text('Calificación: ${actividad.calificacion?.toStringAsFixed(1) ?? "Sin calificar"}\nRespuesta: ${actividad.respuesta}'),
                            trailing: const Icon(Icons.edit),
                            onTap: () => _mostrarDetalleActividad(context, actividad),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarGrafica(context),
        label: const Text('Ver gráfica'),
        icon: const Icon(Icons.bar_chart),
      ),
    );
  }

  void _mostrarDetalleActividad(BuildContext context, RespuestaActividad actividad) {
    final calificacionController = TextEditingController(text: actividad.calificacion?.toString() ?? '');
    final comentarioController = TextEditingController(text: actividad.comentarioMaestro ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Respuesta del alumno:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(actividad.respuesta),
            const SizedBox(height: 20),
            TextField(
              controller: calificacionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calificación (máx 10)',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Lo manejará el profesor en otro lado
            ),
            const SizedBox(height: 10),
            TextField(
              controller: comentarioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentario del maestro',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _mostrarGrafica(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            children: [
              const Text('Rendimiento por Actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            int i = value.toInt();
                            if (i >= 0 && i < respuestas.length) {
                              return Text('${i + 1}', style: const TextStyle(fontSize: 12));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    barGroups: respuestas
                        .asMap()
                        .entries
                        .map((entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.calificacion ?? 0,
                                  color: Colors.blue,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
