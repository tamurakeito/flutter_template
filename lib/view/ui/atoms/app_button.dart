import 'package:flutter/material.dart';
import 'package:flutter_template/view/ui/molecules/loading_circle_mini.dart';

class AppButton extends StatelessWidget {
  final String label;
  final MaterialColor color;
  final void Function()? handlePress;
  final ValueNotifier<bool>? isLoading;
  const AppButton({
    super.key,
    required this.label,
    required this.color,
    required this.handlePress,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handlePress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            return color.shade100;
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return color.withOpacity(0.3);
            }
            return null;
          },
        ),
      ),
      child: isLoading != null && isLoading!.value
          ? const LoadingCircleMini()
          : Text(
              label,
              style: TextStyle(
                color: color.shade900,
              ),
            ),
    );
  }
}
