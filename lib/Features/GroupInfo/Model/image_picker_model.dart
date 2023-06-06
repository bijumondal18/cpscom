import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ImagePickerList {
  final String? title;
  final Widget? icon;

  ImagePickerList(this.title, this.icon);
}

final List<ImagePickerList> pickerList = [
  // ImagePickerList('Gallery', const Icon(EvaIcons.imageOutline)),
  // ImagePickerList('Camera', const Icon(EvaIcons.cameraOutline))
  ImagePickerList(
      "File",
      const Icon(
        Icons.file_copy,
        color: Colors.blue,
      )),
  ImagePickerList('Gallery', Image.asset(AppIcons.galleryIcon)),
  ImagePickerList('Camera', Image.asset(AppIcons.cameraIcon))
];
