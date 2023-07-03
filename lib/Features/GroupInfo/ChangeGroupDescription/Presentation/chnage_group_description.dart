import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Home/Model/response_groups_list.dart';
import '../../Presentation/group_info_screen.dart';

class ChangeGroupDescription extends StatefulWidget {
  final String groupId;

  const ChangeGroupDescription({Key? key, required this.groupId})
      : super(key: key);

  @override
  State<ChangeGroupDescription> createState() => _ChangeGroupDescriptionState();
}

class _ChangeGroupDescriptionState extends State<ChangeGroupDescription> {
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //descController.text = widget.groupId['group_description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.shimmer,
        appBar: const CustomAppBar(
          title: 'Group Description',
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
                    'Add Group Description',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.black),
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.kDefaultPadding / 2,
                        AppSizes.kDefaultPadding / 6,
                        AppSizes.kDefaultPadding / 2,
                        0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppSizes.cardCornerRadius / 2),
                        border:
                            Border.all(width: 1, color: AppColors.lightGrey)),
                    child: StreamBuilder(
                        stream: FirebaseProvider.getGroupDescription(
                            widget.groupId),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                descController.text =
                                    snapshot.data?['group_description'];
                                return CustomTextField(
                                  controller: descController,
                                  hintText: 'Enter Group Description Here...',
                                  minLines: 8,
                                  maxLines: 10,
                                  autoFocus: true,
                                  isBorder: false,
                                );
                              }
                          }
                          return const SizedBox();
                        }),
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
                    FullButton(
                        label: 'Ok'.toUpperCase(),
                        onPressed: () {
                          FirebaseProvider.updateGroupDescription(
                              widget.groupId, descController.text);
                          customSnackBar(
                            context,
                            'Group Description Updated Successfully',
                          );
                          context.pop(GroupInfoScreen(groupId: widget.groupId),
                              descController.text);
                        }),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              maximumSize:
                                  const Size.fromHeight(AppSizes.buttonHeight)),
                          onPressed: () {
                            context.pop(GroupInfoScreen(
                              groupId: widget.groupId,
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
      ),
    );
  }
}
