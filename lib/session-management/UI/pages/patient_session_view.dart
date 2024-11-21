import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_track_flutter_app/session-management/services/session_service.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';
import '../../../shared/model/patient_entity.dart';
import '../../../shared/services/professional_service.dart';

class PatientSessionView extends StatefulWidget {
  final int patientId;
  final String token;

  const PatientSessionView({required this.patientId, required this.token, Key? key}) : super(key: key);

  @override
  _PatientSessionViewState createState() => _PatientSessionViewState();
}

class _PatientSessionViewState extends State<PatientSessionView> {
  final TextEditingController _sessionDateController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _sessionsWithNamesFuture;
  final sessionService = SessionService();
  final patientService = PatientService();
  final professionalService = ProfessionalService();
  List<String> patientNames = [];

  @override
  void initState() {
    super.initState();
    _fetchSessionsWithNames();
  }

  void _fetchSessionsWithNames() {
    setState(() {
      _sessionsWithNamesFuture = _getSessionsWithNames();
    });
  }

  Future<List<Map<String, dynamic>>> _getSessionsWithNames() async {
    try {
      final sessionsWithNames = <Map<String, dynamic>>[];
      final sessions = await sessionService.findByPatientId(widget.patientId, widget.token);

      for (var session in sessions) {
        final associatedName = await professionalService.getProfessionalNameById(session.professionalId, widget.token).catchError((_) => 'Unknown');

        sessionsWithNames.add({
          'sessionDate': session.sessionDate,
          'associatedName': associatedName,
        });
      }
      return sessionsWithNames;
    } catch (e) {
      return Future.error('Failed to load sessions');
    }
  }



  void _registerSession() async {
    final sessionDate = _sessionDateController.text;
    final patientId = _patientIdController.text;

    if (sessionDate.isEmpty || patientId.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(sessionDate);
      final sessionData = {
        'patientId': int.parse(patientId),
        'professionalId': widget.patientId,
        'sessionDate': date.toIso8601String(),
      };

      await sessionService.createSession(sessionData, widget.token);
      Navigator.of(context).pop();
      _fetchSessionsWithNames();
      _showSnackBar('Session registered successfully');
    } catch (e) {
      _showSnackBar('Invalid date format or patient ID');
    }
  }

  void _showAddSessionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildSessionForm(),
        );
      },
    );
  }

  Widget _buildSessionForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting patient
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Select Patient'),
                  isExpanded: true,
                  items: patientNames.map((name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _patientIdController.text = value ?? '';
                    });
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
              // Session Date Field
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _sessionDateController,
                  decoration: InputDecoration(
                    labelText: 'Session Date',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              // Register Session Button
              Center(
                child: ElevatedButton(
                  onPressed: _registerSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Register Session', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Sessions'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _sessionsWithNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No sessions found', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final session = snapshot.data![index];
                final formattedDate = DateFormat('yyyy-MM-dd').format(session['sessionDate']);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Text(
                      'Date: $formattedDate',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Professional: ${session['associatedName']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSessionForm,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}