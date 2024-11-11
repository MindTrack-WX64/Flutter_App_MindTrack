import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/diagnostic/UI/pages/diagnostic_edit_view.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';

class DiagnosticView extends StatefulWidget {
  final String token;
  final int treatmentId;

  DiagnosticView({required this.token, required this.treatmentId});

  @override
  _DiagnosticViewState createState() => _DiagnosticViewState();
}

class _DiagnosticViewState extends State<DiagnosticView> with RouteAware {
  late Future<List<String>> _diagnosticsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDiagnostics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the RouteObserver
    ModalRoute.of(context)!.addScopedWillPopCallback(() async {
      _fetchDiagnostics();
      return true;
    });
  }

  @override
  void dispose() {
    // Unsubscribe from the RouteObserver
    ModalRoute.of(context)!.removeScopedWillPopCallback(() async {
      _fetchDiagnostics();
      return true;
    });
    super.dispose();
  }

  void _fetchDiagnostics() {
    setState(() {
      _diagnosticsFuture = TreatmentService().getDiagnosticsByTreatmentId(widget.treatmentId, widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostics'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiagnosticEditView(
                    token: widget.token,
                    treatmentId: widget.treatmentId,
                  ),
                ),
              ).then((_) => _fetchDiagnostics());
            },
            child: Text('Add Diagnostic'),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _diagnosticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No diagnostics found'));
          } else {
            final diagnostics = snapshot.data!;
            return ListView.builder(
              itemCount: diagnostics.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(diagnostics[index]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}