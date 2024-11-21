import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/UI/pages/clinical_professional_view.dart';
import 'package:mind_track_flutter_app/session-management/UI/pages/session_view.dart';

import '../../../diagnostic/UI/pages/diagnosticView.dart';
import '../../../shared/services/treatment_service.dart';


class PatientMainPage extends StatelessWidget {
  final int patientId;
  final String token;

  PatientMainPage({required this.patientId, required this.token});

  Future<void> _navigateToDiagnostic(BuildContext context, int patientId) async {
    final treatmentService = TreatmentService();

    try {
      final treatmentPlanId = await treatmentService.getTreatmentPlanIdByPatientId(patientId, token);
      print('Treatment plan ID: $treatmentPlanId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosticView(
            token: token,
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
            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Clinical History',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClinicalHistoryPage(patientId: patientId,role: "patient" , token: token),
                  ),
                );
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Diagnostic',
              onPressed: () {
                print("patient id: $patientId");
                _navigateToDiagnostic(context, patientId);
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Prescription',
              onPressed: () {
                // Handle prescription button press
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Task',
              onPressed: () {
                // Handle task button press
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Sessions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionView(patientId: patientId, token: token, role: "patient"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        minimumSize: Size(double.infinity, 60), // Full width and height
        elevation: 6.0, // Shadow to make the button pop
      ),
    );
  }
}