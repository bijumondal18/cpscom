import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Commons/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const SpinKitFadingCube(
            //       color: Palette.primary,
            //       size: 40,
            //     ),
            //     const SizedBox(height: AppSizes.dimen20),
            //     Text(
            //       'Loading...',
            //       style: Theme.of(context).textTheme.bodyText1,
            //     )
            //   ],
            // )
            Center(
                child: Platform.isAndroid
                    ? const AndroidLoadingDialog()
                    : const IosLoadingIndicator()));
  }
}

class AndroidLoadingDialog extends StatelessWidget {
  const AndroidLoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: AppColors.primary,
    );
  }
}

class IosLoadingIndicator extends StatelessWidget {
  const IosLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator();
  }
}
