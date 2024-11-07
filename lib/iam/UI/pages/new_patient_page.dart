import 'dart:convert';
import "package:mind_track_flutter_app/clinical-history/services/clinical_history_service.dart";
import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';
import 'package:mind_track_flutter_app/iam/services/new_patient_service.dart';
import 'package:mind_track_flutter_app/clinical-history/model/clinical_history_entity.dart';
import 'package:mind_track_flutter_app/shared/model/tratment_plan.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';
import "package:mind_track_flutter_app/prescription-management/service/prescription_service.dart";

class NewPatientPage extends StatefulWidget {
  final String token;
  final int professionalId;


  NewPatientPage({required this.token, required this.professionalId});

  @override
  _NewPatientPageState createState() => _NewPatientPageState();
}

class _NewPatientPageState extends State<NewPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _backgroundController = TextEditingController();
  final _consultationReasonController = TextEditingController();

  void _createPatient() async {
    if (_formKey.currentState!.validate()) {
      final newPatient = Patient(
        patientId: 0,
        username: _usernameController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        birthDate: DateTime.parse(_birthDateController.text),
      );

      final newPatientService = NewPatientService();
      final clinicalHistoryService = ClinicalHistoryService();
      final treatmentService = TreatmentService();
      final prescriptionService = PrescriptionService();

      try {
        print(newPatient.toJson());
        print(widget.token);
        final response = await newPatientService.createPatient(newPatient, widget.token);
        final responseData = json.decode(response.body);
        final patientId = responseData['id'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient created successfully with ID: $patientId')),
        );

        final newClinicalHistory = ClinicalHistory(
          patientId: patientId,
          background: _backgroundController.text,
          consultationReason: _consultationReasonController.text,
          consultationDate: DateTime.now().toIso8601String(),
        );

        print("in clinical service");
        print(newClinicalHistory.toJson());
        await clinicalHistoryService.createClinicalHistory(newClinicalHistory, widget.token);

        final newTreatmentPlan = TreatmentPlan.basic(
          patientId: patientId,
          professionalId: widget.professionalId,
          description: " ",
        );
        print("in treatment service");
        print(newTreatmentPlan.toJson());

        await treatmentService.createTreatmentPlan(newTreatmentPlan, widget.token);

        final prescriptionData = {
          "patientId": patientId,
          "professionalId": widget.professionalId,
          "startDate": DateTime.now().toIso8601String(),
          "endDate": DateTime.now().toIso8601String(),
        };

        await prescriptionService.createPrescription(prescriptionData, widget.token);

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create patient: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Birth Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a birth date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _backgroundController,
                decoration: InputDecoration(labelText: 'Background'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a background';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _consultationReasonController,
                decoration: InputDecoration(labelText: 'Consultation Reason'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a consultation reason';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createPatient,
                child: Text('Create Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}