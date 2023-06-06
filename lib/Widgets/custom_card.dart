import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;

  const CustomCard(
      {Key? key,
      required this.child,
      this.padding,
      this.margin,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: padding ?? EdgeInsets.zero,
        margin: margin ?? const EdgeInsets.only(bottom:AppSizes.kDefaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius),
            border: Border.all(color: AppColors.bg, width: 1),
            color: AppColors.white,
            boxShadow:  [
              BoxShadow(
                offset: const Offset(-2, -2),
                blurRadius: 2,
                color: AppColors.lightGrey.withOpacity(0.2),
              ),
              BoxShadow(
                offset: const Offset(2, 2),
                blurRadius: 2,
                color: AppColors.lightGrey.withOpacity(0.2),
              ),
            ]),
        child: child,
      ),
    );
  }
}
