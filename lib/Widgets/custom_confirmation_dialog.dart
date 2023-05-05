import 'package:cpscom_admin/Commons/route.dart';
import 'package:flutter/material.dart';
import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

enum ViewDialogsAction { Confirm, Cancel }

class ViewDialogs {
  static Future<ViewDialogsAction> confirmationDialog(
    BuildContext context,
    String title,
    String body,
    String positiveButtonLabel,
    String negativeButtonLabel,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius / 2),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(ViewDialogsAction.Cancel),
              child: Text(
                negativeButtonLabel,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(ViewDialogsAction.Confirm),
              child: Text(
                positiveButtonLabel,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : ViewDialogsAction.Cancel;
  }
}
