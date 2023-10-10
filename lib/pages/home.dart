import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Test {
  final String id;
  final String nombre;
  final String edad;
  final String telefono;

  Test({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.telefono,
  });
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Test'),
    );
  }
}
