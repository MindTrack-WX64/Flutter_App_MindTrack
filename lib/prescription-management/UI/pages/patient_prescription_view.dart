import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_track_flutter_app/prescription-management/UI/pages/pills_view.dart';
import 'package:mind_track_flutter_app/prescription-management/service/prescription_service.dart';
import 'package:mind_track_flutter_app/shared/services/patient_service.dart';


class PatientPrescriptionView extends StatefulWidget {
  final int patientId;
  final String token;
  final int professionalId;

  PatientPrescriptionView({required this.patientId, required this.professionalId, required this.token});

  @override
  _PatientPrescriptionViewState createState() => _PatientPrescriptionViewState();
}

class _PatientPrescriptionViewState extends State<PatientPrescriptionView> {
  late Future<List<Map<String, dynamic>>> _prescriptionsWithNamesFuture;
  final prescriptionService = PrescriptionService();
  final patientService = PatientService();

  @override
  void initState() {
    super.initState();
    _fetchPrescriptionsWithNames();
  }

  void _fetchPrescriptionsWithNames() {
    setState(() {
      _prescriptionsWithNamesFuture = _getPrescriptionsWithNames();
    });
  }

  Future<List<Map<String, dynamic>>> _getPrescriptionsWithNames() async {
    try {
      final prescriptions = await prescriptionService.getPrescriptionsByPatientId(widget.patientId, widget.token);
      final prescriptionsWithNames = <Map<String, dynamic>>[];

      for (var prescription in prescriptions) {
        var patientName = await patientService.getPatientNameById(prescription.patientId, widget.token)
            .catchError((_) => 'Unknown');
        prescriptionsWithNames.add({
          'startDate': prescription.startDate.toString(),
          'endDate': prescription.endDate.toString(),
          'patientName': patientName,
          'pills': prescription.pills ?? [],  // Assuming 'pills' is an array in prescription
          'prescriptionId': prescription.prescriptionId,  // Assuming 'id' is the prescription ID
        });
      }
      return prescriptionsWithNames;
    } catch (e) {
      return Future.error('Failed to load prescriptions or no prescriptions found');
    }
  }

  void _showPrescriptionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildPrescriptionForm(),
        );
      },
    );
  }

  Widget _buildPrescriptionForm() {
    final _formKey = GlobalKey<FormState>();
    final _startDateController = TextEditingController();
    final _endDateController = TextEditingController();

    void _createPrescription() {
      if (_formKey.currentState!.validate()) {
        try {
          final prescription = {
            'patientId': widget.patientId,
            'professionalId': widget.professionalId,
            'startDate': DateTime.parse(_startDateController.text).toIso8601String(),
            'endDate': DateTime.parse(_endDateController.text).toIso8601String(),
          };

          final prescriptionService = PrescriptionService();
          prescriptionService.createPrescription(prescription, widget.token);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription created successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error creating prescription')),
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
              // Start Date Field
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a start date';
                    }
                    return null;
                  },
                ),
              ),
              // End Date Field
              Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                child: TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an end date';
                    }
                    return null;
                  },
                ),
              ),
              // Create Prescription Button
              Center(
                child: ElevatedButton(
                  onPressed: _createPrescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Create Prescription', style: TextStyle(fontSize: 16, color: Colors.white)),
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
        title: Text('Patient Prescriptions'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // FutureBuilder to load prescriptions
        future: _prescriptionsWithNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No prescriptions found', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final prescriptionsWithNames = snapshot.data!;
            return ListView.builder(
              itemCount: prescriptionsWithNames.length,
              itemBuilder: (context, index) {
                final prescription = prescriptionsWithNames[index];
                final formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(prescription['startDate']));
                final formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(prescription['endDate']));
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ExpansionTile(
                    leading: Icon(Icons.medical_services, color: Colors.blueAccent),
                    title: Text(
                      'Start Date: $formattedStartDate\nEnd Date: $formattedEndDate',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Patient: ${prescription['patientName']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    children: [
                      // Expandable section showing pill details and the button to add pills
                      ListTile(
                        trailing: TextButton(
                          onPressed: () => _navigateToPillsView(prescription),
                          child: Text('See Pills', style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPrescriptionForm,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Function to navigate to the PillsView
  void _navigateToPillsView(Map<String, dynamic> prescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PillsView(
          pills: prescription['pills'],
          prescriptionId: prescription['prescriptionId'],
          token: widget.token, // Pass the pills to the PillsView
        ),
      ),
    );
  }
}


