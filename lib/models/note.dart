import 'package:flutter/material.dart';

class Note {
  String id;
  final String text;
  final String description;
  final Color color;

  Note({
    required this.id,
    required this.text,
    required this.description,
    required this.color,
  });
}
