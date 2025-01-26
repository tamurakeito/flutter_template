import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_template/view/ui/atoms/app_input.dart';

class PasswordInput extends HookWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  const PasswordInput({
    super.key,
    required this.controller,
    required this.label,
    this.color = Colors.indigo,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);

    return AppInput(
      controller: controller,
      label: label,
      color: color,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      obscureText: !isVisible.value,
      iconButton: IconButton(
        icon: Icon(!isVisible.value ? Icons.visibility : Icons.visibility_off),
        onPressed: () => isVisible.value = !isVisible.value,
      ),
    );
  }
}
