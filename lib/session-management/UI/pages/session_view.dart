import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/session-management/services/session_service.dart';
import 'package:mind_track_flutter_app/session-management/model/session_entity.dart';

class SessionView extends StatefulWidget {
  final int patientId;
  final int professionalId;
  final String token;

  SessionView({required this.patientId, required this.professionalId, required this.token});

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  late Future<List<SessionEntity>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  void _fetchSessions() {
    setState(() {
      _sessionsFuture = _getSessions();
    });
  }

  Future<List<SessionEntity>> _getSessions() async {
    final sessionService = SessionService();
    final sessions = await sessionService.findByProfessionalId(widget.professionalId, widget.token);
    if (sessions.isNotEmpty) {
      return sessions;
    } else {
      throw Exception('No sessions found for patient');
    }
  }

  void _showAddSessionDialog() {
    final _dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Session'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                SessionEntity sessionData = SessionEntity(
                  patientId: widget.patientId,
                  professionalId: widget.professionalId,
                  sessionDate: DateTime.parse(_dateController.text),
                );
                try {
                  final sessionService = SessionService();
                  await sessionService.create(sessionData, widget.token);
                  _fetchSessions(); // Refresh the sessions list
                } catch (e) {
                  // Handle error
                  print('Failed to create session: $e');
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
      ),
      body: FutureBuilder<List<SessionEntity>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sessions found'));
          } else {
            final sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Date: ${session.sessionDate}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSessionDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}