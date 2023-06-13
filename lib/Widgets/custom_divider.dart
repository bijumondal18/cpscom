import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final double? height;

  const CustomDivider({Key? key, this.height = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: AppColors.lightGrey,
    );
    //   Divider(
    //   height: height!,
    //   thickness: 0.1,
    //   color: AppColors.black,
    // );
  }
}
