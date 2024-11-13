import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/UI/pages/clinical_professional_view.dart';
import 'package:mind_track_flutter_app/diagnostic/UI/pages/diagnosticView.dart';
import 'package:mind_track_flutter_app/iam/UI/pages/new_patient_page.dart';
import 'package:mind_track_flutter_app/prescription-management/UI/pages/prescription_view.dart';
import 'package:mind_track_flutter_app/session-management/UI/pages/session_view.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';
import 'package:mind_track_flutter_app/task-management/UI/pages/task_view.dart';

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
    final patientService = PatientService();
    final patients = await patientService.getPatientsByProfessionalId(widget.professionalId, widget.token);
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

  Future<void> _navigateToDiagnostics(BuildContext context, int patientId) async {
    final treatmentService = TreatmentService();

    try {
      final treatmentPlanId = await treatmentService.getTreatmentPlanIdByPatientId(patientId, widget.token);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosticView(
            token: widget.token,
            treatmentId: treatmentPlanId,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching treatment plan ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load treatment plan ID')),
      );
    }
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClinicalHistoryPage(
                                      patientId: patient.patientId,
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Clinical History'),
                            ),
                            ElevatedButton(
                              onPressed: () => _navigateToDiagnostics(context, patient.patientId),
                              child: Text('Diagnostic'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                               /* Navigator.push(
                                    context,
                                  MaterialPageRoute(
                                    builder: (context) => PrescriptionView(
                                      patientId: patient.patientId,
                                      professionalId: widget.professionalId,
                                      token: widget.token,
                                    ),
                                  ),
                                );*/
                              },
                              child: Text('Prescription'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TasksPage(
                                      patientId: patient.patientId,
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Tasks'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SessionView(
                                      patientId: patient.patientId,
                                      professionalId: widget.professionalId,
                                      token: widget.token,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Sessions'),
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPatientPage(
                professionalId: widget.professionalId,
                token: widget.token,
              ),
            ),
          );
        }, // Navegar a la página de agregar paciente
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
