import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
class ImagePickerList{
  final String? title;
  final Icon? icon;

  ImagePickerList(this.title, this.icon);
}

final List<ImagePickerList> pickerList = [
  ImagePickerList('Gallery', const Icon(EvaIcons.imageOutline)),
  ImagePickerList('Camera', const Icon(EvaIcons.cameraOutline))
];