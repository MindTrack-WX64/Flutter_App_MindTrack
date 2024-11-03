import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/register_service.dart';
import 'package:mind_track_flutter_app/shared/model/professional_entity.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _professionalTypeController = TextEditingController();
  final RegisterService _registerService = RegisterService();

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final birthDateStr = _birthDateController.text;
    final professionalType = _professionalTypeController.text;

    if (username.isEmpty || password.isEmpty || fullName.isEmpty || email.isEmpty || phone.isEmpty || birthDateStr.isEmpty || professionalType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final birthDate = DateFormat('yyyy-MM-dd').parseStrict(birthDateStr);

      final professional = Professional(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
        phone: phone,
        birthDate: birthDate,
        professionalType: professionalType,
      );

      await _registerService.register(professional);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
      Navigator.pop(context); // Regresa a la página de login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Birth Date'),
            ),
            TextField(
              controller: _professionalTypeController,
              decoration: InputDecoration(labelText: 'Professional Type'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}