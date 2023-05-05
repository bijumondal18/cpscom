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
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius / 2),
            border: Border.all(color: AppColors.shimmer, width: 1),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(-3, -3),
                blurRadius: 10,
                color: AppColors.shimmer,
              ),
              BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 10,
                color: AppColors.shimmer,
              ),
            ]),
        child: child,
      ),
    );
  }
}
