import 'package:flutter/material.dart';

// dekorasyon

InputDecoration buildInputDecoration(String label, String hint) {
  return InputDecoration(
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.deepPurple)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0)),
      labelText: label,
      hintText: hint);
}
