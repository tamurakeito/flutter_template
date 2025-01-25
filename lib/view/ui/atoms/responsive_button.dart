import 'package:flutter/material.dart';
import 'package:flutter_template/view/ui/atoms/app_text.dart';
import 'package:flutter_template/view/ui/molecules/loading_circle_mini.dart';

class ResponsiveButton extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;
  final bool isLoading;
  const ResponsiveButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: TextButton(
        onPressed: !isLoading ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return color.withOpacity(0.6);
              }
              return color;
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.2);
              }
              return null;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // 角丸を設定
            ),
          ),
        ),
        child: !isLoading
            ? AppText(
                label,
                style: AppTextStyle.h2,
                type: AppTextColor.white,
              )
            : const LoadingCircleMini(
                type: LoadingCircleMiniColor.white,
              ),
      ),
    );
  }
}
