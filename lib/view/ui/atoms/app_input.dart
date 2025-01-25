import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.color = Colors.indigo,
    this.focusNode,
    this.onEditingComplete,
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
      ),
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
    );
  }
}
