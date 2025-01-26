import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final bool obscureText;
  final IconButton? iconButton;
  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.color = Colors.indigo,
    this.focusNode,
    this.onEditingComplete,
    this.obscureText = false,
    this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color, // フォーカス時の色を変更
            width: 2.0,
          ),
        ),
        suffixIcon: iconButton,
      ),
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      obscureText: obscureText,
    );
  }
}
