import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Commons/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final int? minLines;
  final int? maxLines;
  final bool? readOnly;
  final bool? autoFocus;
  final bool? isBorder;
  final bool? obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool? isReplying;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final Map<String, dynamic>? replyMessage;
  final VoidCallback? onCancelReply;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.labelText = '',
    this.errorText,
    this.minLines,
    this.maxLines,
    this.validator,
    this.readOnly,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
    this.onChanged,
    this.autoFocus = false,
    this.isBorder = true,
    this.focusNode,
    this.replyMessage,
    this.onCancelReply,
    this.isReplying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // isReplying == true
        //     ? Container(
        //         width: MediaQuery.of(context).size.width,
        //         margin:
        //             const EdgeInsets.only(bottom: AppSizes.kDefaultPadding / 2),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Container(
        //               height: 30,
        //               width: 4,
        //               color: AppColors.primary,
        //               margin: const EdgeInsets.only(
        //                   right: AppSizes.kDefaultPadding / 2),
        //             ),
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     replyMessage!['sendBy'],
        //                     maxLines: 1,
        //                     overflow: TextOverflow.ellipsis,
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .bodyLarge!
        //                         .copyWith(color: AppColors.primary),
        //                   ),
        //                   const SizedBox(
        //                     height: AppSizes.kDefaultPadding / 4,
        //                   ),
        //                   Text(replyMessage!['message'],
        //                       maxLines: 1,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: Theme.of(context).textTheme.bodyMedium),
        //                 ],
        //               ),
        //             ),
        //             IconButton(
        //                 onPressed: onCancelReply,
        //                 icon: const Icon(
        //                   EvaIcons.close,
        //                   size: 24,
        //                   color: AppColors.darkGrey,
        //                 ))
        //           ],
        //         ),
        //       )
        //     : const SizedBox(),
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          //first letter will be capital
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: readOnly ?? false,
          validator: validator,
          obscureText: obscureText ?? false,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType ?? TextInputType.text,
          cursorColor: AppColors.primary,
          controller: controller,
          onChanged: onChanged,
          autofocus: autoFocus!,
          focusNode: focusNode,
          decoration: isBorder!
              ? InputDecoration(
                  suffixIcon: suffixIcon,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSizes.kDefaultPadding),
                  //border: InputBorder.none,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  hintText: hintText ?? '',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  errorText: controller.text == "" ? errorText : null)
              : InputDecoration(
                  suffixIcon: suffixIcon,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSizes.kDefaultPadding),
                  hintText: hintText ?? '',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  errorText: controller.text == "" ? errorText : null),
        ),
      ],
    );
  }
}
