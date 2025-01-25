import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_template/view/assets/style.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math';

class LoadingCircleMini extends HookWidget {
  final LoadingCircleMiniColor? type;
  const LoadingCircleMini({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Color color;

    switch (type) {
      case LoadingCircleMiniColor.light:
        color = kGray600;
        break;
      case LoadingCircleMiniColor.white:
        color = kWhite;
        break;
      default:
        color = kGray800;
        break;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2.0 * pi,
          child: child,
        );
      },
      child: Icon(
        LineIcons.circleNotched,
        color: color,
        size: 18,
      ),
    );
  }
}

enum LoadingCircleMiniColor { dark, light, white }
