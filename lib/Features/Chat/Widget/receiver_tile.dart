import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Features/Chat/Presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:linkable/linkable.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class ReceiverTile extends StatelessWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String sentByName;
  final String sentByImageUrl;
  final String groupCreatedBy;

  const ReceiverTile(
      {Key? key,
      required this.message,
      required this.messageType,
      required this.sentTime,
      required this.sentByName,
      this.sentByImageUrl = '',
      required this.groupCreatedBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageType == 'notify'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: AppSizes.kDefaultPadding),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding,
                    vertical: AppSizes.kDefaultPadding / 2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.lightGrey),
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius / 2),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 1,
                          color: AppColors.lightGrey),
                      BoxShadow(
                          offset: Offset(-1, -1),
                          blurRadius: 1,
                          color: AppColors.lightGrey)
                    ],
                    color: AppColors.shimmer),
                child: Text(
                  '$groupCreatedBy $message',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.kDefaultPadding / 4,
                top: AppSizes.kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.kDefaultPadding * 4 - 2),
                  child: Row(
                    children: [
                      Text(
                        sentByName,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ', $sentTime',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.cardCornerRadius * 3),
                      child: CachedNetworkImage(
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          imageUrl: sentByImageUrl,
                          placeholder: (context, url) => const CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.bg,
                              ),
                          errorWidget: (context, url, error) => CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.bg,
                                child: Text(
                                  sentByName
                                      .substring(0, 1)
                                      .toString()
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              )),
                    ),
                    const SizedBox(
                      width: AppSizes.kDefaultPadding / 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSizes.kDefaultPadding * 2,
                      ),
                      child: ChatBubble(
                        padding: messageType == 'img' ||
                                messageType == 'pdf' ||
                                messageType == 'docx' ||
                                messageType == 'doc'
                            ? EdgeInsets.zero
                            : null,
                        clipper:
                            ChatBubbleClipper3(type: BubbleType.receiverBubble),
                        backGroundColor: AppColors.lightGrey,
                        alignment: Alignment.topLeft,
                        elevation: 0,
                        margin: const EdgeInsets.only(
                            top: AppSizes.kDefaultPadding / 4),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65),
                          child: messageType == 'img'
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ShowImage(imageUrl: message)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.cardCornerRadius),
                                    child: CachedNetworkImage(
                                      imageUrl: message,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                      errorWidget: (context, url, error) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                    ),
                                  ),
                                )
                              : messageType == 'text'
                                  ? Linkable(
                                      text: message,
                                      linkColor: Colors.blue,
                                    )
                                  : messageType == 'pdf'
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.cardCornerRadius),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30),
                                            child: SfPdfViewer.network(
                                              message,
                                              canShowPaginationDialog: false,
                                              canShowScrollHead: false,
                                              canShowScrollStatus: false,
                                              pageLayoutMode:
                                                  PdfPageLayoutMode.continuous,
                                              canShowPasswordDialog: false,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
