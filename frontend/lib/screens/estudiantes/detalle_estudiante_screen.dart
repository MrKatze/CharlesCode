import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import '../../../models/usuario.dart';
import '../../../models/respuestas.dart'; // importa tu modelo
import '../../core/services/actividades_service.dart'; // importa tu servicio

// InputFormatter para limitar la calificación entre 0 y 10 con un decimal máximo
class CalificacionInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Permitir campo vacío para borrar
    if (text.isEmpty) return newValue;

    // Permitir solo números con punto decimal (hasta un decimal)
    final regex = RegExp(r'^\d{0,2}(\.\d{0,1})?$');
    if (!regex.hasMatch(text)) return oldValue;

    final value = double.tryParse(text);
    if (value == null) return oldValue;

    if (value < 0 || value > 10) return oldValue;

    return newValue;
  }
}

class DetalleEstudianteScreen extends StatefulWidget {
  final Usuario estudiante;

  const DetalleEstudianteScreen({super.key, required this.estudiante});

  @override
  State<DetalleEstudianteScreen> createState() =>
      _DetalleEstudianteScreenState();
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
      final data = await ActividadService.obtenerRespuestasPorAlumno(
        widget.estudiante.idUsuario,
      );
      if (!mounted) return;
      setState(() {
        respuestas = data;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar respuestas: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Separar actividades contestadas y no contestadas
    final contestadas =
        respuestas.where((a) => (a.respuesta ?? '').isNotEmpty).toList();
    final noContestadas =
        respuestas.where((a) => (a.respuesta ?? '').isEmpty).toList();
    return Scaffold(
      appBar: AppBar(title: Text('Progreso de ${widget.estudiante.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            cargando
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(widget.estudiante.nombre),
                        subtitle: const Text('Alumno de programación'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Actividades contestadas:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _mostrarGrafica(context),
                          icon: const Icon(Icons.bar_chart),
                          label: const Text('Ver gráfica'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ...contestadas.map(
                            (actividad) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.assignment_turned_in,
                                  color: Colors.green,
                                ),
                                title: Text(actividad.titulo),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: HighlightView(
                                        actividad.respuesta,
                                        language: 'python',
                                        theme: vs2015Theme, // Tema oscuro
                                        padding: const EdgeInsets.all(8),
                                        textStyle: const TextStyle(
                                          fontFamily: 'Fira Mono',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Calificación: ${actividad.calificacion?.toString() ?? 'Sin calificar'}',
                                    ),
                                    Text(
                                      'Comentario: ${actividad.comentarioMaestro ?? ''}',
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed:
                                      () => _mostrarDetalleActividad(
                                        context,
                                        actividad,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Actividades no contestadas:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...noContestadas.map(
                            (actividad) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.assignment_late,
                                  color: Colors.red,
                                ),
                                title: Text(actividad.titulo),
                                subtitle: const Text('Sin respuesta'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  void _mostrarDetalleActividad(
    BuildContext context,
    RespuestaActividad actividad,
  ) {
    final calificacionController = TextEditingController(
      text: actividad.calificacion?.toString() ?? '',
    );
    final comentarioController = TextEditingController(
      text: actividad.comentarioMaestro ?? '',
    );
    final respuestaController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título: ${actividad.titulo}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text('Descripción: ${actividad.descripcion}'),
                  const SizedBox(height: 5),
                  Text(
                    'Fecha de entrega: ${actividad.fechaEntrega?.toString().split(' ')[0] ?? 'Sin fecha'}',
                  ),
                  const SizedBox(height: 15),
                  if ((actividad.respuesta ?? '').isNotEmpty) ...[
                    Text(
                      'Respuesta del alumno:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: HighlightView(
                        actividad.respuesta,
                        language: 'python',
                        theme: vs2015Theme, // Tema oscuro
                        padding: const EdgeInsets.all(8),
                        textStyle: const TextStyle(
                          fontFamily: 'Fira Mono',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: calificacionController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        CalificacionInputFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Calificación (máx 10)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: comentarioController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Comentario del maestro',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text('Guardar calificación'),
                      onPressed: () async {
                        final nuevaCalificacion = double.tryParse(
                          calificacionController.text,
                        );
                        final nuevoComentario = comentarioController.text;
                        if (nuevaCalificacion == null ||
                            nuevaCalificacion < 0 ||
                            nuevaCalificacion > 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ingresa una calificación válida entre 0 y 10',
                              ),
                            ),
                          );
                          return;
                        }
                        if (actividad.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No se puede calificar una actividad sin respuesta.',
                              ),
                            ),
                          );
                          return;
                        }
                        final exito =
                            await ActividadService.actualizarCalificacionRespuesta(
                              idRespuesta: actividad.id!,
                              calificacion: nuevaCalificacion,
                              comentarioMaestro: nuevoComentario,
                            );
                        if (!mounted) return;
                        if (exito) {
                          setState(() {
                            actividad.calificacion = nuevaCalificacion;
                            actividad.comentarioMaestro = nuevoComentario;
                          });
                          Navigator.pop(context);
                          _cargarRespuestas();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Calificación y comentario actualizados',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error al actualizar la calificación',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: 10),
                    Text('El alumno no ha respondido esta actividad.'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: respuestaController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Respuesta del alumno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Enviar respuesta como alumno'),
                      onPressed: () async {
                        final respuesta = respuestaController.text.trim();
                        if (respuesta.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'La respuesta no puede estar vacía',
                              ),
                            ),
                          );
                          return;
                        }
                        final exito = await ActividadService.enviarRespuesta(
                          actividad.idActividad,
                          actividad.idAlumno,
                          respuesta,
                        );
                        if (!mounted) return;
                        if (exito) {
                          Navigator.pop(context);
                          _cargarRespuestas();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Respuesta enviada exitosamente'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al enviar respuesta'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
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
              const Text(
                'Rendimiento por Actividad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                              return Text(
                                '${i + 1}',
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    barGroups:
                        respuestas
                            .asMap()
                            .entries
                            .map(
                              (entry) => BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.calificacion ?? 0,
                                    color: Colors.blue,
                                    width: 16,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            )
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
