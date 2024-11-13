import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/iam/UI/pages/new_patient_page.dart';
import 'package:mind_track_flutter_app/patient-management/UI/pages/patient-list.dart';
import 'package:mind_track_flutter_app/prescription-management/UI/pages/prescription_form.dart';
import 'package:mind_track_flutter_app/prescription-management/UI/pages/prescription_view.dart';
import 'package:mind_track_flutter_app/session-management/UI/pages/session_view.dart';

class ProfessionalMainPage extends StatelessWidget {
  final int professionalId;
  final String token;

  ProfessionalMainPage({required this.professionalId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MindTrack', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.person, size: 30, color: Colors.white),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome, Professional!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 40), // Space for better separation

            // Patient Management Button
            _buildStyledButton(
              icon: Icons.people,
              label: 'Patient Management',
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
            ),
            SizedBox(height: 20),

            // Prescription Button
            _buildStyledButton(
              icon: Icons.receipt,
              label: 'Prescriptions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionView(
                      token: token,
                      professionalId: professionalId,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Appointments Button
            _buildStyledButton(
              icon: Icons.calendar_today,
              label: 'Appointments',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionView(
                      patientId: 4,
                      professionalId: professionalId,
                      token: token,
                    ),
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
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 28),
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
