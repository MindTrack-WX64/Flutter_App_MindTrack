import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/services/clinical_history_service.dart';

import '../../model/clinical_history_entity.dart';

class ClinicalHistoryPage extends StatefulWidget {
  final int patientId;
  final String token;
  final String role;

  const ClinicalHistoryPage({required this.patientId, required this.role, required this.token});

  @override
  _ClinicalHistoryPageState createState() => _ClinicalHistoryPageState();
}

class _ClinicalHistoryPageState extends State<ClinicalHistoryPage> {
  late Future<ClinicalHistory> _clinicalHistoryFuture;
  final _backgroundController = TextEditingController();
  final _consultationReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _clinicalHistoryFuture = _fetchClinicalHistory();
  }

  Future<ClinicalHistory> _fetchClinicalHistory() async {
    final clinicalHistoryService = ClinicalHistoryService();
    return await clinicalHistoryService.getByPatientId(widget.patientId, widget.token);
  }

  void _showUpdateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildUpdateForm(),
        );
      },
    );
  }

  Widget _buildUpdateForm() {
    final _formKey = GlobalKey<FormState>();

    void _updateClinicalHistory() async {
      if (_formKey.currentState!.validate()) {
        try {
          final clinicalHistoryService = ClinicalHistoryService();
          var clinic = await clinicalHistoryService.getByPatientId(widget.patientId, widget.token);
          print(clinic.toJson());
          print(clinic.clinicalId);
          await clinicalHistoryService.updateById(
            clinic.clinicalId,
            widget.token,
            _backgroundController.text,
            _consultationReasonController.text,
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clinical history updated successfully')),
          );
          setState(() {
            _clinicalHistoryFuture = _fetchClinicalHistory();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating clinical history')),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Background Field
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _backgroundController,
                  decoration: InputDecoration(
                    labelText: 'Background',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a background';
                    }
                    return null;
                  },
                ),
              ),
              // Consultation Reason Field
              Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                child: TextFormField(
                  controller: _consultationReasonController,
                  decoration: InputDecoration(
                    labelText: 'Consultation Reason',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a consultation reason';
                    }
                    return null;
                  },
                ),
              ),
              // Update Button
              Center(
                child: ElevatedButton(
                  onPressed: _updateClinicalHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Update', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical History'),
        actions: [
          if (widget.role == "professional")
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showUpdateForm,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-display.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<ClinicalHistory>(
            future: _clinicalHistoryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No clinical history found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              } else {
                final clinicalHistory = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              icon: Icons.history,
                              label: 'Background',
                              value: clinicalHistory.background,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              icon: Icons.note_alt_outlined,
                              label: 'Consultation Reason',
                              value: clinicalHistory.consultationReason,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              label: 'Consultation Date',
                              value: clinicalHistory.consultationDate,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 8.0),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
