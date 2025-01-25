import 'package:flutter/material.dart';
import 'package:flutter_template/view/assets/style.dart';

class AppText extends StatelessWidget {
  final String data;
  final AppTextStyle style;
  final AppTextColor? type;
  const AppText(this.data, {super.key, required this.style, this.type});

  @override
  Widget build(BuildContext context) {
    double size;
    FontWeight weight;
    Color color;
    switch (style) {
      case AppTextStyle.h1:
        size = kFontSizeHeadlineH1;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.h2:
        size = kFontSizeHeadlineH2;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.h3:
        size = kFontSizeHeadlineH3;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.h4:
        size = kFontSizeHeadlineH4;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.h5:
        size = kFontSizeHeadlineH5;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.h6:
        size = kFontSizeHeadlineH6;
        weight = FontWeight.bold;
        break;
      case AppTextStyle.lg:
        size = kFontSizeTextLg;
        weight = FontWeight.normal;
        break;
      case AppTextStyle.md:
        size = kFontSizeTextMd;
        weight = FontWeight.normal;
        break;
      case AppTextStyle.sm:
        size = kFontSizeTextSm;
        weight = FontWeight.normal;
        break;
      case AppTextStyle.xs:
        size = kFontSizeTextXs;
        weight = FontWeight.normal;
        break;
      default:
        size = kFontSizeNomal;
        weight = FontWeight.normal;
        break;
    }

    switch (type) {
      case AppTextColor.light:
        color = kGray600;
        break;
      case AppTextColor.white:
        color = kWhite;
        break;
      default:
        color = kGray900;
        break;
    }

    return Text(
      data,
      style: TextStyle(
        fontFamily: 'NotoSansJP',
        fontSize: size,
        fontWeight: weight,
        height: 1.0,
        color: color,
      ),
    );
  }
}

enum AppTextStyle { h1, h2, h3, h4, h5, h6, lg, md, sm, xs }

enum AppTextColor { dark, light, white }
