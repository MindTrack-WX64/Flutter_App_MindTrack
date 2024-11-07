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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-professional-main.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
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
                  icon: Icon(Icons.people, color: Colors.white),
                  label: Text('Patient Management'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    minimumSize: Size(double.infinity, 60),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
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
                  icon: Icon(Icons.person_add, color: Colors.white),
                  label: Text('Add Patient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    minimumSize: Size(double.infinity, 60),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle appointments button press
                  },
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text('Appointments'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    minimumSize: Size(double.infinity, 60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}