import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Features/Chat/Presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class SenderTile extends StatelessWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String groupCreatedBy;

  const SenderTile(
      {Key? key,
      required this.message,
      required this.messageType,
      required this.sentTime,
      required this.groupCreatedBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageType == 'notify'
        ? Container(
            margin:
                const EdgeInsets.symmetric(vertical: AppSizes.kDefaultPadding),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.kDefaultPadding,
                vertical: AppSizes.kDefaultPadding / 2),
            decoration:
                BoxDecoration(color: AppColors.lightGrey.withOpacity(0.8)),
            child: Text(
              '$groupCreatedBy $message',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(
                right: AppSizes.kDefaultPadding, top: AppSizes.kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    sentTime,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 12),
                  ),
                ),
                ChatBubble(
                  clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                  backGroundColor: AppColors.secondary.withOpacity(0.3),
                  alignment: Alignment.topRight,
                  elevation: 0,
                  margin:
                      const EdgeInsets.only(top: AppSizes.kDefaultPadding / 4),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65),
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
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator.adaptive(),
                                errorWidget: (context, url, error) =>
                                    const CircularProgressIndicator.adaptive(),
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
                                              0.45,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30),
                                      child: SfPdfViewer.network(
                                        message,
                                        canShowPaginationDialog: false,
                                        canShowScrollHead: false,
                                        canShowScrollStatus: false,
                                        pageLayoutMode:
                                            PdfPageLayoutMode.single,
                                        canShowPasswordDialog: false,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                  ),
                ),
              ],
            ),
          );
  }
}
