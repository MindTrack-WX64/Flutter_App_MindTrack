import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/clinical-history/model/clinical_history_entity.dart';
import 'package:mind_track_flutter_app/clinical-history/services/clinical_history_service.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-display.png'), // Ruta de la imagen
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
                return Container(// Light background
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: ListView(
                        children: [
                          _buildReadOnlyField(
                            label: 'Background',
                            value: clinicalHistory.background,
                            icon: Icons.history,
                          ),
                          SizedBox(height: 16),
                          _buildReadOnlyField(
                            label: 'Consultation Reason',
                            value: clinicalHistory.consultationReason,
                            icon: Icons.note_alt_outlined,
                          ),
                          SizedBox(height: 16),
                          _buildReadOnlyField(
                            label: 'Consultation Date',
                            value: clinicalHistory.consultationDate,
                            icon: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );

  }

  /// Helper function to build a stylized read-only TextFormField
  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      maxLines: value.length > 50 ? 5 : 1, // Adjust max lines based on content
    );
  }
}