import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  final String apiUrl;

  Config({required this.apiUrl});

  static Future<Config> forEnvironment(String env) async {
    final configString = await rootBundle.loadString('environments/config_$env.json');
    final configData = json.decode(configString);
    return Config(
      apiUrl: configData['apiUrl'],
    );
  }
}