import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/services/clinical_history_service.dart';
import 'package:mind_track_flutter_app/clinical-history/model/clinical_history_entity.dart';

class ClinicalHistoryPage extends StatefulWidget {
  final int patientId;
  final String token;

  ClinicalHistoryPage({required this.patientId, required this.token});

  @override
  _ClinicalHistoryPageState createState() => _ClinicalHistoryPageState();
}

class _ClinicalHistoryPageState extends State<ClinicalHistoryPage> {
  late Future<ClinicalHistory> _clinicalHistoryFuture;

  @override
  void initState() {
    print("on clinical page");
    super.initState();
    _clinicalHistoryFuture = _fetchClinicalHistory();
  }

  Future<ClinicalHistory> _fetchClinicalHistory() async {
    final clinicalHistoryService = ClinicalHistoryService();
    return await clinicalHistoryService.getByPatientId(widget.patientId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical History'),
      ),
      body: FutureBuilder<ClinicalHistory>(
        future: _clinicalHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No clinical history found'));
          } else {
            final clinicalHistory = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: clinicalHistory.background,
                      decoration: InputDecoration(labelText: 'Background'),
                      readOnly: true,
                      maxLines: 5, // Make the TextFormField larger
                    ),
                    TextFormField(
                      initialValue: clinicalHistory.consultationReason,
                      decoration: InputDecoration(labelText: 'Consultation Reason'),
                      readOnly: true,
                      maxLines: 5, // Make the TextFormField larger
                    ),
                    TextFormField(
                      initialValue: clinicalHistory.consultationDate,
                      decoration: InputDecoration(labelText: 'Consultation Date'),
                      readOnly: true,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}