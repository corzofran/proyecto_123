import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  // Necesario para que la base de datos local (sqflite) funcione correctamente
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const App());
}
