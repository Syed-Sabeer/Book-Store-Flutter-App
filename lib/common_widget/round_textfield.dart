import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? img; // Add this field for the image

  const RoundTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.img, // Make img an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TColor.textbox, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: hintText,
          labelStyle: const TextStyle(
            fontSize: 15,
          ),
          // Add prefixIcon if img is provided
          prefixIcon: img != null ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(img!, width: 20, height: 20), // Ensure img is loaded
          ) : null,
        ),
      ),
    );
  }
}
