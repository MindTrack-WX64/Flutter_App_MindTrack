import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/prescription-management/service/prescription_service.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';

class PrescriptionForm extends StatefulWidget {
  final String token;
  final int professionalId;

  PrescriptionForm({required this.token, required this.professionalId});

  @override
  _PrescriptionFormState createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _patientController = TextEditingController();
  List<Patient> patients = [];
  Patient? selectedPatient;

  @override
  void initState() {
    super.initState();
    _getPatients();
  }

  Future<void> _getPatients() async {
    final patientService = PatientService();
    try {
      final patientList = await patientService.getPatientsByProfessionalId(widget.professionalId, widget.token);
      setState(() {
        patients = patientList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching patients: $e')),
      );
    }
  }

  void _createPrescription() {
    if (_formKey.currentState!.validate()) {
      try {
        final prescription = {
          'patientId': selectedPatient!.patientId, // Use the selected patient ID
          'professionalId': widget.professionalId,
          'startDate': DateTime.parse(_startDateController.text).toIso8601String(),
          'endDate': DateTime.parse(_endDateController.text).toIso8601String(),
        };

        final prescriptionService = PrescriptionService();
        prescriptionService.createPrescription(prescription, widget.token);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription created successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error creating prescription')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0'); // Agrega un '0' si el mes tiene un solo dígito
    final day = date.day.toString().padLeft(2, '0'); // Agrega un '0' si el día tiene un solo dígito
    return "$year-$month-$day";
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial
      firstDate: DateTime.now(),   // Fecha mínima
      lastDate: DateTime.now().add(const Duration(days: 100)),   // Fecha máxima
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
        _startDateController.text = _formatDate(pickedDate);;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)), // Fecha inicial
      firstDate: DateTime.now().add(const Duration(days: 1)),   // Fecha mínima
      lastDate: DateTime.now().add(const Duration(days: 100)),   // Fecha máxima
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
        _endDateController.text = _formatDate(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for selecting patient
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<Patient>(
                    value: selectedPatient,
                    hint: const Text('Select Patient'),
                    isExpanded: true,
                    items: patients
                        .map((patient) => DropdownMenuItem<Patient>(
                      value: patient,
                      child: Text(patient.fullName),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPatient = value;
                        _patientController.text = value?.patientId.toString() ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a patient';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    ),
                  ),
                ),
                // Start Date Field
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _startDateController,
                    onTap: () => _selectStartDate(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a start date';
                      }
                      return null;
                    },
                  ),
                ),
                // End Date Field
                Container(
                  margin: const EdgeInsets.only(bottom: 24.0),
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    ),
                    onTap: () => _selectEndDate(context),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an end date';
                      }
                      return null;
                    },
                  ),
                ),
                // Create Prescription Button
                Center(
                  child: ElevatedButton(
                    onPressed: _createPrescription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Create Prescription', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
