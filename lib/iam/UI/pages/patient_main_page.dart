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
            ElevatedButton(
              onPressed: () {
                // Handle diagnostic button press
              },
              child: Text('Diagnostic'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ( ) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionView(patientId: patientId, professionalId: 1, token: token),
                  ),
                );


              },
              child: Text('Appointments'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle clinical history button press
              },
              child: Text('Clinical History'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle prescription button press
              },
              child: Text('Prescription'),
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