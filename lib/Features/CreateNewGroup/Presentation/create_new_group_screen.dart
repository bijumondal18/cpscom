import 'dart:io';

import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Bloc/create_group_bloc.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_search_bar.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../Widgets/custom_floating_action_button.dart';

class CreateNewGroupScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? membersList;

  const CreateNewGroupScreen({Key? key, this.membersList}) : super(key: key);

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final TextEditingController grpNameController = TextEditingController();
  final TextEditingController grpDescController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //List<dynamic> membersList = [];

  @override
  Widget build(BuildContext context) {
    print(widget.membersList);
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.shimmer,
        appBar: const CustomAppBar(
          title: 'Create New Group',
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 56,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: AssetImage(
                        AppImages.groupAvatar,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(
                            AppSizes.kDefaultPadding / 1.3),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.lightGrey),
                            color: AppColors.white,
                            shape: BoxShape.circle),
                        child: Image.asset(
                          AppImages.cameraIcon,
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              CustomCard(
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.kDefaultPadding,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppSizes.cardCornerRadius / 2),
                          border:
                              Border.all(width: 1, color: AppColors.lightGrey)),
                      child: CustomTextField(
                        controller: grpNameController,
                        hintText: 'Group Name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid Group Title';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              CustomCard(
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.kDefaultPadding,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppSizes.cardCornerRadius / 2),
                            border: Border.all(
                                width: 1, color: AppColors.lightGrey)),
                        child: CustomTextField(
                          controller: grpDescController,
                          hintText: 'Add Group Description (optional)',
                          minLines: 5,
                          maxLines: 5,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                //decoration: const BoxDecoration(color: AppColors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.kDefaultPadding,
                          AppSizes.kDefaultPadding,
                          AppSizes.kDefaultPadding,
                          0),
                      child: Text(
                        '${widget.membersList!.length} Participants',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget.membersList!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    AppColors.grey.withOpacity(0.5),
                                foregroundImage: NetworkImage(
                                    '${AppStrings.imagePath}${widget.membersList![index]['profile_picture']}'),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 3,
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              FirebaseProvider.createGroup(
                  grpNameController.text,
                  grpDescController.text,
                  '',
                  widget.membersList!,
                  DateFormat('yyyy-mm-dd kk:mm:ss').format(DateTime.now()));

              Future.delayed(const Duration(seconds: 3),
                  () => context.pushAndRemoveUntil(const HomeScreen()));
            }
            return;
          },
          iconData: EvaIcons.arrowForwardOutline,
        ),
      ),
    );
  }
}
