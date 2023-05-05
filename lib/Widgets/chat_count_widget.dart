import 'package:cpscom_admin/Commons/commons.dart';
import 'package:flutter/material.dart';

class ChatCountWidget extends StatelessWidget {
  final int? count;

  const ChatCountWidget({Key? key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      child: Text(
        '$count',
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: AppColors.white),
      ),
    );
  }
}
