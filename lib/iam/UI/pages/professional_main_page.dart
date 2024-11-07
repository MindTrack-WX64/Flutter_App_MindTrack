import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/iam/UI/pages/new_patient_page.dart';
import 'package:mind_track_flutter_app/patient-management/UI/pages/patient-list.dart';
class ProfessionalMainPage extends StatelessWidget {
  final int professionalId;
  final String token;

  ProfessionalMainPage({required this.professionalId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MindTrack'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessionalPatientsPage(
                      professionalId: professionalId,
                      token: token,
                    ),
                  ),
                );
              },
              child: Text('Patient Management'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPatientPage(
                      token: token,
                      professionalId: professionalId,
                    ),
                  ),
                );
              },
              child: Text('Add Patient'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle appointments button press
              },
              child: Text('Appointments'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}