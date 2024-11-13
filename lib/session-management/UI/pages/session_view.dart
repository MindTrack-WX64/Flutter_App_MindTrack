import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_track_flutter_app/session-management/services/session_service.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';
import '../../../shared/model/patient_entity.dart';
import 'add_session_dialog.dart';

class SessionView extends StatefulWidget {
  final int? patientId;
  final int professionalId;
  final String token;

  SessionView({this.patientId, required this.professionalId, required this.token});

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final TextEditingController _sessionDateController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _sessionsWithNamesFuture;
  final sessionService = SessionService();
  final patientService = PatientService();

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
      final sessions = await sessionService.findByProfessionalId(widget.professionalId, widget.token);
      final sessionsWithNames = <Map<String, dynamic>>[];

      for (var session in sessions) {
        var patientName = await patientService.getPatientNameById(session.patientId, widget.token)
            .catchError((_) => 'Unknown');
        sessionsWithNames.add({
          'sessionDate': session.sessionDate,
          'patientName': patientName,
        });
      }
      return sessionsWithNames;
    } catch (e) {
      return Future.error('Failed to load sessions or no sessions found');
    }
  }

  void _register() async {
    final professionalId = widget.professionalId;
    final sessionDate = _sessionDateController.text;
    final patientId = _patientIdController.text;

    if (sessionDate.isEmpty || patientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(sessionDate);
      final sessionData = {
        'patientId': int.parse(patientId),
        'professionalId': professionalId,
        'sessionDate': date.toIso8601String(),
      };

      await sessionService.createSession(sessionData, widget.token);
      Navigator.of(context).pop();
      _fetchSessionsWithNames();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: Invalid date format or patient ID')),
      );
    }
  }

  Future<List<Patient>> _getProfessionalPatients() async {
    try {
      final patients = await patientService.getPatientsByProfessionalId(widget.professionalId, widget.token);
      return patients;
    } catch (e) {
      return Future.error('Failed to load patients');
    }
  }

  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Patient>>(
          future: _getProfessionalPatients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No patients found', style: TextStyle(fontSize: 18, color: Colors.grey)));
            } else {
              return AddSessionDialog(
                sessionDateController: _sessionDateController,
                patientIdController: _patientIdController,
                onRegister: _register,
                patientNames: snapshot.data!,
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sessions',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _sessionsWithNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sessions found', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final sessionsWithNames = snapshot.data!;
            return ListView.builder(
              itemCount: sessionsWithNames.length,
              itemBuilder: (context, index) {
                final session = sessionsWithNames[index];
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
                      'Patient: ${session['patientName']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSessionDialog,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
