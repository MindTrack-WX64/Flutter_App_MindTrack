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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgAddPatient.png'), // Ruta de la imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                color: Colors.white,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _birthDateController,
                        decoration: InputDecoration(
                          labelText: 'Birth Date',
                          prefixIcon: Icon(Icons.calendar_today),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _professionalTypeController,
                        decoration: InputDecoration(
                          labelText: 'Professional Type',
                          prefixIcon: Icon(Icons.work),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.all(10), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}