import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final double? height;

  const CustomDivider({Key? key, this.height = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height!,
      thickness: 0.2,
      color: AppColors.darkGrey.withOpacity(0.8),
    );
  }
}
