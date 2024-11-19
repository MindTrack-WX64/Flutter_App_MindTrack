import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_track_flutter_app/session-management/services/session_service.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';
import '../../../shared/model/patient_entity.dart';
import '../../../shared/services/professional_service.dart';
import 'add_session_dialog.dart';

class SessionView extends StatefulWidget {
  final int? patientId;
  final int? professionalId;
  final String token;

  const SessionView({this.patientId, this.professionalId, required this.token, Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final TextEditingController _sessionDateController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _sessionsWithNamesFuture;
  final sessionService = SessionService();
  final patientService = PatientService();
  final professionalService = ProfessionalService();

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
      final sessions = widget.professionalId != null
          ? await sessionService.findByProfessionalId(widget.professionalId!, widget.token)
          : await sessionService.findByPatientId(widget.patientId!, widget.token);

      for (var session in sessions) {
        final associatedName = widget.professionalId != null
            ? await patientService.getPatientNameById(session.patientId, widget.token).catchError((_) => 'Unknown')
            : await professionalService.getProfessionalNameById(session.professionalId, widget.token).catchError((_) => 'Unknown');

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
        'professionalId': widget.professionalId,
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

  Future<List<Patient>> _getProfessionalPatients() async {
    try {
      return await patientService.getPatientsByProfessionalId(widget.professionalId!, widget.token);
    } catch (e) {
      return Future.error('Failed to load patients');
    }
  }

  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Patient>>(
          future: _getProfessionalPatients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No patients found', style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            } else {
              return AddSessionDialog(
                sessionDateController: _sessionDateController,
                patientIdController: _patientIdController,
                onRegister: _registerSession,
                patientNames: snapshot.data!,
              );
            }
          },
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
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
                      'Name: ${session['associatedName']}',
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
        onPressed: _showAddSessionDialog,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
