import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? iconData;

  const CustomFloatingActionButton(
      {Key? key, required this.onPressed, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, gradient: AppColors.buttonGradientColor),
        child: Icon(
          iconData ?? EvaIcons.arrowForwardOutline,
          size: 24,
          color: AppColors.white,
        ),
      ),
    );
  }
}
