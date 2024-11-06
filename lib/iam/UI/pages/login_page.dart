import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:mind_track_flutter_app/shared/model/user_entity.dart';
import 'register_page.dart';
import 'professional_main_page.dart';
import 'patient_main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    final user = User(username: username, password: password);

    try {
      final response = await _authService.authenticate(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful. User ID: ${response['userId']}')),
      );

      final userId = response['userId'];
      final token = response['token'];
      final roles = List<String>.from(response['roles']);
      print(roles);

      if (roles.contains("PROFESSIONAL")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessionalMainPage(
              professionalId: userId,
              token: token,
            ),
          ),
        );
      }
      if (roles.contains("PATIENT")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientMainPage(
              patientId: userId,
              token: token,
            ),
          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToRegister,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}