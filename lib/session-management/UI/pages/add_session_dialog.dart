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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Agregar Sesión',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            DropdownButtonFormField<Patient>(
              value: _selectedPatient,
              hint: Text('Seleccionar Paciente'),
              items: widget.patientNames
                  .map((patient) => DropdownMenuItem<Patient>(
                value: patient,
                child: Text(patient.fullName),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPatient = value;
                  if (value != null) {
                    widget.patientIdController.text = value.patientId.toString();
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
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
          child: Text('Agregar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
