<<<<<<< Updated upstream
import 'package:cpscom_admin/Commons/app_colors.dart';
=======
import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';

class ImagePickerList {
  final String? title;
  final Widget? icon;

  ImagePickerList(this.title, this.icon);
}

<<<<<<< Updated upstream
final List<ImagePickerList> chatPickerList = [
  ImagePickerList(
      "File",
      const Icon(
        Icons.file_copy,
        color: AppColors.primary,
      )),
  ImagePickerList(
      'Gallery',
      const Icon(
        Icons.image,
        color: AppColors.primary,
      )),
  ImagePickerList(
      'Camera',
      const Icon(
        Icons.camera_alt_rounded,
        color: AppColors.primary,
      ))
];

final List<ImagePickerList> imagePickerList = [
  ImagePickerList(
      'Gallery',
      const Icon(
        Icons.image,
        color: AppColors.primary,
      )),
  ImagePickerList(
      'Camera',
      const Icon(
        Icons.camera_alt_rounded,
        color: AppColors.primary,
      ))
];
=======
final List<ImagePickerList> pickerList = [
  // ImagePickerList('Gallery', const Icon(EvaIcons.imageOutline)),
  // ImagePickerList('Camera', const Icon(EvaIcons.cameraOutline))
  ImagePickerList('Gallery', Image.asset(AppIcons.galleryIcon)),
  ImagePickerList('Camera', Image.asset(AppIcons.cameraIcon))
];
>>>>>>> Stashed changes
