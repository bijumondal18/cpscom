import 'package:flutter/material.dart';
import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

enum ViewDialogsAction { Confirm, Cancel }

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String body;
  final String? negativeButtonLabel;
  final String? positiveButtonLabel;
  final VoidCallback onPressedPositiveButton;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.onPressedPositiveButton,
    this.negativeButtonLabel = 'Cancel',
    this.positiveButtonLabel = 'Confirm',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius / 2),
      ),
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(ViewDialogsAction.Cancel),
          child: Text(
            negativeButtonLabel!,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        TextButton(
          onPressed: onPressedPositiveButton,
          child: Text(
            positiveButtonLabel!,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
