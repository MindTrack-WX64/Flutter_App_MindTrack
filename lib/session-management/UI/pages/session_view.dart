import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/session-management/services/session_service.dart';
import 'package:mind_track_flutter_app/session-management/model/session_entity.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class SessionView extends StatefulWidget {
  final int patientId;
  final int professionalId;
  final String token;

  SessionView({required this.patientId, required this.professionalId, required this.token});

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final TextEditingController _sessionDateController = TextEditingController();
  late Future<List<SessionEntity>> _sessionsFuture;
  final sessionService = SessionService();


  @override
  void initState() {
    super.initState();
    print("Professional ID: ${widget.professionalId}");
    print("Token: ${widget.token}");
    _fetchSessions();
  }


  void _fetchSessions() {
    setState(() {
      _sessionsFuture = _getSessions();
    });
  }

  void _register() async {
    const patientId = 3;
    final professionalId = widget.professionalId;
    final sessionDate = _sessionDateController.text;

    if (sessionDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(sessionDate); // Format 'yyyy-MM-dd'

      // Create the session data as a Map
      final sessionData = {
        'patientId': patientId,
        'professionalId': professionalId,
        'sessionDate': date.toIso8601String(),
      };

      // Pass the session data to the service
      await sessionService.createSession(sessionData, widget.token);

      // Close the dialog after a successful registration
      Navigator.of(context).pop();

      // Refresh the list of sessions
      _fetchSessions();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } catch (e) {
      // Show error message if session creation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
  }



  Future<List<SessionEntity>> _getSessions() async {
    try {
      final sessions = await sessionService.findByProfessionalId(widget.professionalId, widget.token);
      return sessions;
    } catch (e) {
      throw Exception('Failed to load sessions: $e');
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
                  controller: _sessionDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
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
              onPressed: _register,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  bool _isValidDate(String date) {
    // Verifica si la fecha está en el formato 'yyyy-mm-dd'
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
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
                final formattedDate = DateFormat('yyyy-MM-dd').format(session.sessionDate); // Formato 'yyyy-MM-dd'
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Date: $formattedDate'),
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
