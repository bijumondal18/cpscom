import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:flutter/material.dart';

import '../../../../Commons/app_colors.dart';
import '../../../../Commons/app_sizes.dart';
import '../../../../Widgets/custom_app_bar.dart';
import '../../../../Widgets/custom_text_field.dart';
import '../../../../Widgets/full_button.dart';
import '../../../Home/Model/response_groups_list.dart';

class ChangeGroupTitle extends StatefulWidget {
  final QueryDocumentSnapshot groupDetails;

  const ChangeGroupTitle({Key? key, required this.groupDetails, })
      : super(key: key);

  @override
  State<ChangeGroupTitle> createState() => _ChangeGroupTitleState();
}

class _ChangeGroupTitleState extends State<ChangeGroupTitle> {
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.groupDetails['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shimmer,
      appBar: const CustomAppBar(
        title: 'Enter New Title',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Group Title',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: AppColors.black),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                CustomTextField(
                  controller: titleController,
                  hintText: 'Business Group 1',
                )
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.kDefaultPadding * 2),
              child: Column(
                children: [
                  FullButton(label: 'Ok'.toUpperCase(), onPressed: () {}),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            maximumSize:
                                const Size.fromHeight(AppSizes.buttonHeight)),
                        onPressed: () {
                          context.pop(GroupInfoScreen(
                            groupDetails: widget.groupDetails,
                          ));
                        },
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
