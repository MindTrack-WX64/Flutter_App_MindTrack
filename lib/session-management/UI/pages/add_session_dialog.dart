import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';

class AddSessionDialog extends StatefulWidget {
  final TextEditingController sessionDateController;
  final TextEditingController patientIdController;
  final VoidCallback onRegister;
  final List<Patient>? patientNames;
  final Patient? patient;

  AddSessionDialog({
    required this.sessionDateController,
    required this.patientIdController,
    required this.onRegister,
    this.patientNames,
    this.patient,
  });

  @override
  _AddSessionDialogState createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    // Si se pasa un solo paciente, seleccionarlo por defecto
    if (widget.patient != null) {
      _selectedPatient = widget.patient;
      widget.patientIdController.text = widget.patient!.patientId.toString();
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0'); // Agrega un '0' si el mes tiene un solo dígito
    final day = date.day.toString().padLeft(2, '0'); // Agrega un '0' si el día tiene un solo dígito
    return "$year-$month-$day";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Fecha inicial
      firstDate: DateTime.now(),
      // Fecha mínima
      lastDate: DateTime.now().add(const Duration(days: 30)),
      // Fecha máxima
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent,
              // Color principal
              onPrimary: Colors.white,
              // Color de texto en el botón seleccionado
              onSurface: Colors.black, // Color del texto del calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors
                    .blueAccent, // Color de los botones (CANCELAR/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.sessionDateController.text = _formatDate(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no se pasa un paciente específico, usamos la lista
    final patientsToShow = widget.patientNames ?? [];

    return AlertDialog(
      title: Text(
        'Agregar Sesión',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de fecha de sesión
            TextField(
              controller: widget.sessionDateController,
              decoration: InputDecoration(
                labelText: 'Fecha de la Sesión',
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
            ),
            SizedBox(height: 16.0),

            // Si hay un solo paciente, mostramos un TextField, si hay varios, mostramos un Dropdown
            patientsToShow.isEmpty && widget.patient != null
                ? TextField(
              controller: widget.patientIdController,
              decoration: InputDecoration(
                labelText: 'Paciente',
                hintText: _selectedPatient?.fullName,
                prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              enabled: false, // Solo lectura si ya hay un paciente
            )
                : DropdownButtonFormField<Patient>(
              value: _selectedPatient,
              hint: Text('Seleccionar Paciente'),
              items: patientsToShow
                  .map((patient) => DropdownMenuItem<Patient>(
                value: patient,
                child: Text(patient.fullName),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPatient = value;
                  if (value != null) {
                    widget.patientIdController.text =
                        value.patientId.toString();
                  }
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Botón cancelar
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        // Botón agregar
        ElevatedButton(
          onPressed: () {
            if (_selectedPatient == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Por favor selecciona un paciente')),
              );
              return;
            }
            widget.onRegister();
          },
          child: Text('Agregar', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}