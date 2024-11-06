import 'package:flutter/material.dart';
import '../../model/clinical_history_entity.dart';
import '../../services/clinical_history_service.dart';

class ClinicalHistoryViewPage extends StatefulWidget {
  final int clinicalId;
  final String token;

  ClinicalHistoryViewPage({required this.clinicalId, required this.token});

  @override
  _ClinicalHistoryViewPageState createState() => _ClinicalHistoryViewPageState();
}

class _ClinicalHistoryViewPageState extends State<ClinicalHistoryViewPage> {
  late ClinicalHistoryService _clinicalHistoryService;
  ClinicalHistory? _clinicalHistory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _clinicalHistoryService = ClinicalHistoryService();
    _fetchClinicalHistory();
  }

  Future<void> _fetchClinicalHistory() async {
    try {
      ClinicalHistory clinicalHistory = await _clinicalHistoryService.getById(widget.clinicalId.toString(),widget.token);
      setState(() {
        _clinicalHistory = clinicalHistory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical History'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _clinicalHistory == null
          ? Center(child: Text('Failed to load clinical history'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _clinicalHistory!.patientId.toString(),
              decoration: InputDecoration(labelText: 'Patient ID'),
              readOnly: true,
            ),
            TextFormField(
              initialValue: _clinicalHistory!.background,
              decoration: InputDecoration(labelText: 'Background'),
              readOnly: true,
            ),
            TextFormField(
              initialValue: _clinicalHistory!.consultationReason,
              decoration: InputDecoration(labelText: 'Consultation Reason'),
              readOnly: true,
            ),
            TextFormField(
              initialValue: _clinicalHistory!.consultationDate,
              decoration: InputDecoration(labelText: 'Consultation Date'),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}