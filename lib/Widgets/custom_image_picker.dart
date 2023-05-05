import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';
import '../Features/GroupInfo/Model/image_picker_model.dart';
import '../Utils/custom_bottom_modal_sheet.dart';

class CustomImagePicker extends StatefulWidget {
  //final UserDetailsStateLoaded state;

  const CustomImagePicker({
    Key? key,
    // required this.state,
  }) : super(key: key);

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? image;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (kDebugMode) {
        print(imageTemp);
      }
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (kDebugMode) {
        print(imageTemp);
      }
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          bottom: AppSizes.dimen30,
          top: AppSizes.dimen16,
          left: AppSizes.dimen16,
          right: AppSizes.dimen16),
      child: Center(
        child: Stack(
          children: [
            // SizedBox(
            //   child: CircleAvatar(
            //     maxRadius: 60,
            //     backgroundColor: AppColors.lightGrey,
            //     backgroundImage: (image != null)
            //         ? Image.file(File(image!.path)).image
            //         : (widget.state.userDetailsResponseModel.data![0]
            //                     .profileImage !=
            //                 null)
            //             ? NetworkImage(
            //                 '${Urls.baseUrl}user_images/${widget.state.userDetailsResponseModel.data![0].profileImage}')
            //             : Image.asset('assets/images/profile-avatar.png').image,
            //   ),
            //   width: MediaQuery.of(context).size.width * 0.3,
            // ),
            Positioned(
                left: 77,
                bottom: 06,
                child: InkWell(
                  onTap: () {
                    showCustomBottomSheet(
                        context,
                        '',
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: pickerList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      pickImageFromGallery();
                                      break;
                                    case 1:
                                      pickImageFromCamera();
                                      break;
                                  }
                                  Navigator.pop(context);
                                },
                                leading: pickerList[index].icon,
                                title: Text(pickerList[index].title!,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              );
                            }));
                  },
                  child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.shimmer,
                      child: Icon(
                        EvaIcons.camera,
                        color: AppColors.primary,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
