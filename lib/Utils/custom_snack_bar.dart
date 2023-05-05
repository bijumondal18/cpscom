import 'package:flutter/material.dart';
import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

ScaffoldMessengerState customSnackBar(
    BuildContext context, String msg, Color backgroundColor) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          elevation: AppSizes.elevation0,
          content: Text(
            msg,
            style: const TextStyle(
                fontSize: AppSizes.bodyText1,
                color: AppColors.white,
                fontWeight: FontWeight.w500),
          )),
    );
}
