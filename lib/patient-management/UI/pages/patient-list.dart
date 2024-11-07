import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';
import "package:mind_track_flutter_app/shared/model/patient_entity.dart";

class ProfessionalPatientsPage extends StatefulWidget {
  final int professionalId;
  final String token;

  ProfessionalPatientsPage({required this.professionalId, required this.token});

  @override
  _ProfessionalPatientsPageState createState() => _ProfessionalPatientsPageState();
}

class _ProfessionalPatientsPageState extends State<ProfessionalPatientsPage> {
  late Future<List<Patient>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _patientsFuture = _fetchPatients();
  }

  Future<List<Patient>> _fetchPatients() async {
    final treatmentService = TreatmentService();
    final patientService = PatientService();
    print("Fetching patients for professionalId: ${widget.professionalId} with token: ${widget.token}");

    print("In _fetchPatients");
    final treatments = await treatmentService.getByProfessionalId(widget.professionalId, widget.token);
    print("In _fetchPatients2");
    print("Fetched treatments: $treatments");

    final patientIds = treatments.map((treatment) => treatment.patientId).toSet();
    print("Patient IDs: $patientIds");

    List<Patient> patients = [];
    for (int patientId in patientIds) {
      final patient = await patientService.getByPatientId(patientId, widget.token);
      print("Fetched patient: $patient");
      patients.add(patient);
    }
    print("All fetched patients: $patients");
    return patients;
  }

  int _calculateAge(String birthDate) {
    final birthDateParsed = DateTime.parse(birthDate);
    final today = DateTime.now();
    int age = today.year - birthDateParsed.year;
    if (today.month < birthDateParsed.month || (today.month == birthDateParsed.month && today.day < birthDateParsed.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching patients: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error ?? 'Unknown error'}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients registered'));
          } else {
            final patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(minHeight: 300), // Set larger minimum height
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(patient.fullName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone: ${patient.phone}'),
                              Text('Age: ${_calculateAge(patient.birthDate.toString())}'),
                            ],
                          ),
                        ),
                        Divider(),
                        Wrap(
                          spacing: 8,
                          children: [
                            ElevatedButton(onPressed: () {}, child: Text('Clinical History')),
                            ElevatedButton(onPressed: () {}, child: Text('Diagnostic')),
                            ElevatedButton(onPressed: () {}, child: Text('Prescription')),
                            ElevatedButton(onPressed: () {}, child: Text('Patient Status')),
                            ElevatedButton(onPressed: () {}, child: Text('Tasks')),
                            ElevatedButton(onPressed: () {}, child: Text('Session')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}