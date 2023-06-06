import 'package:cached_network_image/cached_network_image.dart';
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
                child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    imageUrl: '',
                    placeholder: (context, url) =>  Container(),
                    errorWidget: (context, url, error) => Container()),
              );
            }));
  }
}
