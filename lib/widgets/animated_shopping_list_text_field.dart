import 'package:flutter/material.dart';
import 'package:shopping_list_app/colors.dart';

class AnimatedShoppingListTextField extends StatelessWidget {
  final TextEditingController itemNameController;
  const AnimatedShoppingListTextField({
    super.key,
    required this.itemNameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: itemNameController,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(30.0)), // Grey border with small radius
          borderSide: BorderSide(color: Colors.grey, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15.0), // Blue border with larger radius
          borderSide: const BorderSide(color: kVioletColor, width: 3),
        ),
        hintText: "Enter item name",
      ),
    );
  }
}
