import 'package:flutter/material.dart';

import '../branding/brand_assets.dart';

/// لوگوی NediCar با حفظ نسبت تصویر و بدون کشیدگی.
class NediCarLogo extends StatelessWidget {
  const NediCarLogo({
    super.key,
    this.height = 56,
    this.semanticLabel = 'لوگوی NediCar',
  });

  final double height;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image.asset(
        BrandAssets.logo,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
