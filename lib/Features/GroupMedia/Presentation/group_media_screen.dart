import 'package:cpscom_admin/Commons/commons.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_app_bar.dart';

class GroupMediaScreen extends StatefulWidget {
  const GroupMediaScreen({Key? key}) : super(key: key);

  @override
  State<GroupMediaScreen> createState() => _GroupMediaScreenState();
}

class _GroupMediaScreenState extends State<GroupMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Group Media',
        ),
        body: GridView.builder(
            itemCount: 7,
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSizes.kDefaultPadding,
                crossAxisSpacing: AppSizes.kDefaultPadding),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppSizes.cardCornerRadius / 2),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.45,
                  decoration: const BoxDecoration(color: AppColors.lightGrey),
                ),
              );
            }));
  }
}
