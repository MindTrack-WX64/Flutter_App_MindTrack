import 'dart:convert';
import "package:mind_track_flutter_app/clinical-history/services/clinical_history_service.dart";
import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/model/patient_entity.dart';
import 'package:mind_track_flutter_app/iam/services/new_patient_service.dart';
import 'package:mind_track_flutter_app/clinical-history/model/clinical_history_entity.dart';
import 'package:mind_track_flutter_app/shared/model/tratment_plan.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';

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

  void _createPatient() async {
    if (_formKey.currentState!.validate()) {
      final newPatient = Patient(
        username: _usernameController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        birthDate: DateTime.parse(_birthDateController.text),
      );

      final newPatientService = NewPatientService();
      final clinicalHistoryService = ClinicalHistoryService();
      
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
          background: '',
          consultationReason: '',
          consultationDate: DateTime.now().toString(),
        );

        await clinicalHistoryService.create(newClinicalHistory, widget.token);


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