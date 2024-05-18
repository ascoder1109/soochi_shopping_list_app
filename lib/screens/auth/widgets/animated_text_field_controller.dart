import 'package:flutter/material.dart';
import 'package:soochi/colors.dart';

class AnimatedTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const AnimatedTextField({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(color: Colors.grey, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: kVioletColor, width: 3),
        ),
        hintText: hint,
      ),
    );
  }
}
