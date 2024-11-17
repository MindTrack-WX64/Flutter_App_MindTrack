import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/session-management/UI/pages/session_view.dart';

class PatientMainPage extends StatelessWidget {
  final int patientId;
  final String token;

  PatientMainPage({required this.patientId, required this.token});

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
              label: 'Diagnostic',
              onPressed: () {
                // Handle diagnostic button press
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Appointments',
              onPressed: ( ) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionView(patientId: patientId, professionalId: 1, token: token),
                  ),
                );
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Clinical History',
              onPressed: () {
                // Handle diagnostic button press
              },
            ),

            SizedBox(height: 30),
            _buildStyledButton(
              label: 'Prescription',
              onPressed: () {
                // Handle diagnostic button press
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