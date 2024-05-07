import 'package:flutter/material.dart';
import 'package:shopping_list_app/colors.dart';

class AnimatedTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Color textColor;

  const AnimatedTextField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: textColor),
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
          borderSide: const BorderSide(color: kVioletColor, width: 3),
        ),
        hintText: hint,
      ),
    );
  }
}
