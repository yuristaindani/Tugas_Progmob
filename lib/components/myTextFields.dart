import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator; // Validator function

  const MyTextFields({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.enabled,
    this.validator, // Validator function as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 28, 95, 30)),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: validator, // Assign validator function
    );
  }
}
