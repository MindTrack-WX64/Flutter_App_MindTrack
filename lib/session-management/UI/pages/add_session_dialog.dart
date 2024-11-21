import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';

class AddSessionDialog extends StatefulWidget {
  final TextEditingController sessionDateController;
  final TextEditingController patientIdController;
  final VoidCallback onRegister;
  final List<Patient> patientNames;

  AddSessionDialog({
    required this.sessionDateController,
    required this.patientIdController,
    required this.onRegister,
    required this.patientNames,
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
              keyboardType: TextInputType.datetime,
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


