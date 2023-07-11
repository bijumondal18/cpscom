import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Software Licenses',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
        child: Text(
          AppStrings.license,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
