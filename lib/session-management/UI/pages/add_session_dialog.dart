import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';

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
    if (widget.patient != null) {
      _selectedPatient = widget.patient;
      widget.patientIdController.text = widget.patient!.patientId.toString();
    }

  }


  Future<void> requestCalendarPermission() async {
    var status = await Permission.calendar.status;
    if (!status.isGranted) {
      status = await Permission.calendar.request();
      if (status.isGranted) {
        print("Permiso concedido");
      } else {
        print("Permiso denegado");
      }
    }
  }


  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0'); // Agrega un '0' si el mes tiene un solo dígito
    final day = date.day.toString().padLeft(2, '0'); // Agrega un '0' si el día tiene un solo dígito
    return "$year-$month-$day";
  }
  Future<bool> _saveSessionToCalendar() async {
    final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

    // Solicitar permisos si aún no se tienen
    final permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
    if (permissionsGranted == null || !(permissionsGranted.data ?? false)) {
      return false;
    }

    // Obtener calendarios disponibles
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult == null || calendarsResult.data == null || calendarsResult.data!.isEmpty) {
      return false;
    }

    // Seleccionar el primer calendario
    final calendarId = calendarsResult.data!.first.id;

    // Inicializar zonas horarias
    tz_data.initializeTimeZones();

    // Convertir las fechas
    final tz.TZDateTime startDate = tz.TZDateTime.from(
      DateTime.parse(widget.sessionDateController.text),
      tz.local,
    );

    final tz.TZDateTime endDate = startDate.add(Duration(hours: 1));

    // Crear el evento
    final event = Event(
      calendarId!,
      title: 'Sesión con ${_selectedPatient?.fullName ?? 'Paciente'}',
      description: 'Sesión programada con el paciente.',
      start: startDate,
      end: endDate,
    );

    // Guardar el evento en el calendario
    final createResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (createResult == null || createResult.isSuccess == null) {
      return false;
    }

    return createResult.isSuccess!;
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
          onPressed: () async {
            if (_selectedPatient == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Por favor selecciona un paciente')),
              );
              return;
            }

            // Guarda la sesión en el calendario
            final success = await _saveSessionToCalendar();
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sesión guardada en el calendario')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No se pudo guardar en el calendario')),
              );
            }

            widget.onRegister(); // Realiza la acción original
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