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

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0'); // Agrega un '0' si el mes tiene un solo dígito
    final day = date.day.toString().padLeft(2, '0'); // Agrega un '0' si el día tiene un solo dígito
    return "$year-$month-$day";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime.now(),   // Fecha mínima
      lastDate: DateTime.now().add(const Duration(days: 30)),   // Fecha máxima
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent, // Color principal
              onPrimary: Colors.white, // Color de texto en el botón seleccionado
              onSurface: Colors.black, // Color del texto del calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent, // Color de los botones (CANCELAR/OK)
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
    return AlertDialog(
      title: Text(
        'Agregar Sesión',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.sessionDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Fecha de la Sesión',
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a birth date';
                }
                return null;
              },
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
          child: Text('Agregar', style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
