import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../core/services/estadisticas_services.dart';

class EstadisticasScreen extends StatefulWidget {
  final Usuario maestro;
  const EstadisticasScreen({super.key, required this.maestro});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  late Future<List<dynamic>> _promediosFuture;
  late Future<List<dynamic>> _histogramaFuture;
  late Future<List<dynamic>> _progresoFuture;
  late Future<List<dynamic>> _comparativaFuture;

  @override
  void initState() {
    super.initState();
    _promediosFuture = EstadisticasServices.obtenerPromedioAlumnos();
    _histogramaFuture = EstadisticasServices.obtenerHistograma();
    _progresoFuture = EstadisticasServices.obtenerProgreso();
    _comparativaFuture = EstadisticasServices.obtenerComparativa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas de Alumnos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promedio de calificaciones por alumno',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<dynamic>>(
                future: _promediosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay datos para mostrar.'),
                    );
                  }
                  final data = snapshot.data!;
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= data.length)
                                return const SizedBox();
                              return RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  data[idx]['nombre'].toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                            reservedSize: 60,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (i) {
                        final promedio = data[i]['promedio'] ?? 0;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: (promedio is num ? promedio : 0).toDouble(),
                              color: Colors.blue,
                              width: 18,
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Histograma de calificaciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<dynamic>>(
                future: _histogramaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay datos para mostrar.'),
                    );
                  }
                  final data = snapshot.data!;
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= data.length)
                                return const SizedBox();
                              return Text(
                                data[idx]['rango'].toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (i) {
                        final cantidad = data[i]['cantidad'] ?? 0;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: (cantidad is num ? cantidad : 0).toDouble(),
                              color: Colors.green,
                              width: 18,
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Progreso de actividades completadas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<dynamic>>(
                future: _progresoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay datos para mostrar.'),
                    );
                  }
                  final data = snapshot.data!;
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= data.length)
                                return const SizedBox();
                              return RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  data[idx]['nombre'].toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                            reservedSize: 60,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (i) {
                        final completadas =
                            data[i]['actividades_completadas'] ?? 0;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  (completadas is num ? completadas : 0)
                                      .toDouble(),
                              color: Colors.orange,
                              width: 18,
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Comparativa de desempeño',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<dynamic>>(
                future: _comparativaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay datos para mostrar.'),
                    );
                  }
                  final data = snapshot.data!;
                  return ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, i) {
                      final promedio = data[i]['promedio'] ?? 0;
                      final total = data[i]['total_actividades'] ?? 0;
                      return ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(data[i]['nombre'].toString()),
                        subtitle: Text(
                          'Promedio: \\${(double.tryParse(promedio.toString()) ?? 0).toStringAsFixed(2)} | Actividades: $total',
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
