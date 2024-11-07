import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/prescription-management/service/prescription_service.dart';

class PrescriptionView extends StatefulWidget {
  final int patientId;
  final int professionalId;
  final String token;

  PrescriptionView({required this.patientId, required this.professionalId, required this.token});

  @override
  _PrescriptionViewState createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {
  late Future<List<Map<String, dynamic>>> _pillsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPills();
  }

  void _fetchPills() {
    setState(() {
      _pillsFuture = _getPills();
    });
  }

  Future<List<Map<String, dynamic>>> _getPills() async {
    final prescriptionService = PrescriptionService();
    final prescription = await prescriptionService.findByPatientId(widget.patientId, widget.token);
    if (prescription.isNotEmpty) {
      return List<Map<String, dynamic>>.from(prescription['pills']);
    } else {
      throw Exception('No prescriptions found for patient');
    }
  }

  void _showAddPillDialog() {
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _quantityController = TextEditingController();
    final _frequencyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Pill'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _frequencyController,
                  decoration: InputDecoration(labelText: 'Frequency'),
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
                final pillData = {
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'quantity': int.parse(_quantityController.text),
                  'frequency': _frequencyController.text,
                };
                try {
                  final prescriptionService = PrescriptionService();
                  final prescription = await prescriptionService.findByPatientId(widget.patientId, widget.token);
                  final prescriptionId = prescription['prescriptionId'];
                  await prescriptionService.addPill(prescriptionId, pillData, widget.token);
                  _fetchPills(); // Refresh the pills list
                } catch (e) {
                  // Handle error
                  print('Failed to create pill: $e');
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
        title: Text('Prescription Pills'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pillsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pills found'));
          } else {
            final pills = snapshot.data!;
            return ListView.builder(
              itemCount: pills.length,
              itemBuilder: (context, index) {
                final pill = pills[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(pill['name']),
                    subtitle: Text('Description: ${pill['description']}\nQuantity: ${pill['quantity']}\nFrequency: ${pill['frequency']}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPillDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}