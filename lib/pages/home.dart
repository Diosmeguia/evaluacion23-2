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
