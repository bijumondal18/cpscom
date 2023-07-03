import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Commons/app_colors.dart';
import '../../../../Commons/app_sizes.dart';
import '../../../../Utils/custom_snack_bar.dart';
import '../../../../Widgets/custom_app_bar.dart';
import '../../../../Widgets/custom_text_field.dart';
import '../../../../Widgets/full_button.dart';

class ChangeGroupTitle extends StatefulWidget {
  final String groupId;

  const ChangeGroupTitle({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<ChangeGroupTitle> createState() => _ChangeGroupTitleState();
}

class _ChangeGroupTitleState extends State<ChangeGroupTitle> {
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.bg,
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
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('groups')
                          .doc(widget.groupId)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              if (snapshot.data?['name'] != null ||
                                  snapshot.data?['name'] != '') {
                                titleController.text = snapshot.data?['name'];
                              }
                              return CustomTextField(
                                controller: titleController,
                                hintText: 'Group Title',
                                autoFocus: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Group title can't be empty";
                                  }
                                  return null;
                                },
                              );
                            }
                        }
                        return const SizedBox();
                      })
                ],
              ),
            ),
            const Spacer(),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding * 2),
                child: Column(
                  children: [
                    FullButton(
                        label: 'Ok'.toUpperCase(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseProvider.updateGroupTitle(
                                widget.groupId, titleController.text);
                            context
                                .pop(GroupInfoScreen(groupId: widget.groupId));
                            customSnackBar(
                              context,
                              'Group Title Updated Successfully',
                            );
                          }
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
