import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/UI/pages/clinical_professional_view.dart';
import 'package:mind_track_flutter_app/diagnostic/UI/pages/diagnosticView.dart';
import 'package:mind_track_flutter_app/iam/UI/pages/new_patient_page.dart';
import 'package:mind_track_flutter_app/prescription-management/UI/pages/patient_prescription_view.dart';
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
    print('Patients: $patients');
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-display.png'), // Ruta de la imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Patient>>(
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
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        patient.fullName,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Phone: ${patient.phone}'),
                                          Text('Age: ${_calculateAge(patient.birthDate.toString())}'),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                              // Right side: Square options button
                              Container(
                                width: 50, // Square size
                                height: 50,
                                child: IconButton(
                                  icon: Icon(Icons.menu), // Menu icon
                                  onPressed: () {
                                    showMenu(
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                          MediaQuery.of(context).size.width, 100, 10, 0),
                                      items: [
                                        PopupMenuItem<String>(
                                          value: 'Clinical History',
                                          child: Text('Clinical History'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Diagnostic',
                                          child: Text('Diagnostic'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Prescription',
                                          child: Text('Prescription'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Tasks',
                                          child: Text('Tasks'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Sessions',
                                          child: Text('Sessions'),
                                        ),
                                      ],
                                    ).then((selectedOption) {
                                      switch (selectedOption) {
                                        case 'Clinical History':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ClinicalHistoryPage(
                                                patientId: patient.patientId,
                                                token: widget.token,
                                              ),
                                            ),
                                          );
                                          break;
                                        case 'Diagnostic':
                                          _navigateToDiagnostics(context, patient.patientId);
                                          break;
                                        case 'Prescription':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PatientPrescriptionView(
                                                patientId: patient.patientId,
                                                token: widget.token,
                                              ),
                                            ),
                                          );

                                          break;
                                        case 'Tasks':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TasksPage(
                                                patientId: patient.patientId,
                                                token: widget.token,
                                              ),
                                            ),
                                          );
                                          break;
                                        case 'Sessions':
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
                                          break;
                                      }
                                    });
                                  },
                                ),
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
          ),

        ],
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
