import 'package:flutter/material.dart';
import '../../../models/actividad.dart';
import '../../../models/usuario.dart';
import '/core/services/actividades_service.dart';

class CrearActividadScreen extends StatefulWidget {
  final Usuario maestro;

  const CrearActividadScreen({super.key, required this.maestro});

  @override
  State<CrearActividadScreen> createState() => _CrearActividadScreenState();
}

class _CrearActividadScreenState extends State<CrearActividadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();

  String titulo = '';
  String descripcion = '';
  String? fechaEntrega;
  int idLenguaje = 1;

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  String _dosDigitos(int valor) => valor.toString().padLeft(2, '0');

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (seleccionada != null) {
      final String fechaFormateada =
          '${seleccionada.year}-${_dosDigitos(seleccionada.month)}-${_dosDigitos(seleccionada.day)}';
      setState(() {
        _fechaController.text = fechaFormateada;
        fechaEntrega = fechaFormateada;
      });
    }
  }

  Future<void> _guardarActividad() async {
    if (_formKey.currentState!.validate()) {
      final actividad = Actividad(
        titulo: titulo,
        descripcion: descripcion,
        fechaEntrega: fechaEntrega,
        idMaestro: widget.maestro.idUsuario,
        idLenguaje: idLenguaje,
      );

      final exito = await ActividadService.registrarActividad(actividad);

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actividad creada exitosamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear actividad')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Actividad'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  onChanged: (value) => titulo = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => descripcion = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
                  maxLines: 10,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de entrega',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _seleccionarFecha(context),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Selecciona una fecha' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: idLenguaje,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Python')),
                  ],
                  onChanged: (value) => idLenguaje = value!,
                  decoration: const InputDecoration(labelText: 'Lenguaje'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _guardarActividad,
                  child: const Text('Guardar Actividad'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
