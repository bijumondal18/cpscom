import 'dart:io';

import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Bloc/create_group_bloc.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_search_bar.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Widgets/custom_floating_action_button.dart';

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final TextEditingController grpNameController = TextEditingController();
  final TextEditingController grpDescController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppPreference preference = AppPreference();

  @override
  Widget build(BuildContext context) {
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
                    CustomTextField(
                      controller: grpNameController,
                      hintText: 'Group Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid Group Title';
                        }
                        return null;
                      },
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
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.kDefaultPadding / 2,
                            AppSizes.kDefaultPadding / 2,
                            AppSizes.kDefaultPadding / 2,
                            0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppSizes.cardCornerRadius / 2),
                            border: Border.all(
                                width: 1, color: AppColors.lightGrey)),
                        child: CustomTextField(
                          controller: grpDescController,
                          hintText: 'Add Group Description',
                          minLines: 5,
                          maxLines: 5,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 2,
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
                child: HomeSearchBar(
                  searchHint: 'Search members...',
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 2,
              ),
              CustomCard(
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.grey),
                    ),
                    const CustomDivider(
                      height: 15,
                    ),
                    const BuildSuggestedMembersList()
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 3,
              ),
            ],
          ),
        ),
        floatingActionButton: BlocProvider(
          create: (context) => CreateGroupBloc(),
          child: BlocConsumer<CreateGroupBloc, CreateGroupState>(
            listener: (context, state) {
              if (state is CreateGroupStateLoaded) {
                context.pushReplacement(const HomeScreen());
                // customSnackBar(
                //     context,
                //     state.responseCreateGroup.message.toString(),
                //     AppColors.successSnackBarBackground);
              }
              if (state is CreateGroupStateFailed) {
                //customSnackBar(context, state.msg, AppColors.error);
              }
            },
            builder: (context, state) {
              if (state is CreateGroupStateLoading) {
                return Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator();
              }
              if (state is CreateGroupStateInitial) {
                return CustomFloatingActionButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<CreateGroupBloc>(context).add(
                          CreateGroupSubmittedEvent(
                              groupTitle: grpNameController.text,
                              uid: await preference.getUserId()));
                    }
                    return;
                  },
                  iconData: EvaIcons.arrowForwardOutline,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class BuildSuggestedMembersList extends StatefulWidget {
  const BuildSuggestedMembersList({Key? key}) : super(key: key);

  @override
  State<BuildSuggestedMembersList> createState() =>
      _BuildSuggestedMembersListState();
}

class _BuildSuggestedMembersListState extends State<BuildSuggestedMembersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            horizontalTitleGap: AppSizes.kDefaultPadding / 2,
            leading: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.lightGrey,
            ),
            title: Text(
              'joe@abcd.com',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: AppColors.black),
            ),
            trailing: IconButton(
              icon: const Icon(
                EvaIcons.plusCircleOutline,
                size: 24,
                color: AppColors.grey,
              ),
              onPressed: () {},
            ),
          );
        });
  }
}
