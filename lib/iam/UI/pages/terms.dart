import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Para leer el archivo .txt

class TermsAndConditionsPage extends StatelessWidget {
  Future<String> _loadTermsAndConditions() async {
    return await rootBundle.loadString('assets/terms.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: FutureBuilder<String>(
        future: _loadTermsAndConditions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading terms and conditions'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  snapshot.data ?? 'No terms available.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.justify,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}