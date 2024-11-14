import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';

class DiagnosticEditView extends StatefulWidget {
  final String token;
  final int treatmentId;

  DiagnosticEditView({required this.token, required this.treatmentId});

  @override
  _DiagnosticEditViewState createState() => _DiagnosticEditViewState();
}

class _DiagnosticEditViewState extends State<DiagnosticEditView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final treatmentService = TreatmentService();
      final data = {
        "name": _nameController.text,
        "description": _descriptionController.text,
      };
      try {
        await treatmentService.updateDiagnostic(widget.treatmentId, data, widget.token);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Diagnostic updated successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update diagnostic')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Diagnostic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}