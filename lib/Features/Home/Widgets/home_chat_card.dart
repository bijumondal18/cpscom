import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///----Home chat card widgets----///
class HomeChatCard extends StatelessWidget {
  final String groupName;
  final String? groupDesc;
  String? sentTime;
  final String? lastMsg;
  final int? unseenMsgCount;
  final String? imageUrl;
  final VoidCallback onPressed;
  final String groupId;

  HomeChatCard({
    Key? key,
    required this.groupId,
    required this.groupName,
    this.sentTime,
    required this.onPressed,
    this.groupDesc = '',
    this.imageUrl = '',
    this.lastMsg = '',
    this.unseenMsgCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSeenByUser = false;
    final FirebaseAuth auth = FirebaseAuth.instance;
    String lastMsgSenderName = '';
    return SizedBox(
      child: StreamBuilder(
          stream: FirebaseProvider.getLastMessage(groupId),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (snapshot.hasData) {
                  if (snapshot.data != null &&
                      snapshot.data.docs != null &&
                      snapshot.data.docs.length >= 1) {
                    lastMsgSenderName = snapshot.data.docs[0]['sendBy'] ==
                            auth.currentUser!.displayName
                        ? 'You'
                        : snapshot.data.docs[0]['sendBy'] != null
                            ? '${snapshot.data.docs[0]['sendBy']}'
                            : '';
                    sentTime = AppHelper.getStringTimeFromTimestamp(
                        snapshot.data.docs[0]['time']);
                    List<dynamic> chatMembersList = [];
                    // remove unseen count from home screen when user viewed last message.
                    if (snapshot.data.docs[0]['type'] != 'notify') {
                      chatMembersList =
                          snapshot.data.docs[0]['members'] as List<dynamic>;

                      for (var i = 0; i < chatMembersList.length; i++) {
                        if (chatMembersList[i]['uid'] ==
                            auth.currentUser!.uid) {
                          isSeenByUser = chatMembersList[i]['isSeen'];
                        }
                      }
                    }
                  }
                  return InkWell(
                    onTap: () => onPressed.call(),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(AppSizes.kDefaultPadding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.cardCornerRadius * 10),
                                child: CachedNetworkImage(
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  imageUrl: '$imageUrl',
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.shimmer,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.shimmer,
                                    child: Text(
                                      groupName
                                          .substring(0, 1)
                                          .toString()
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.kDefaultPadding),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              groupName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          (snapshot.data != null &&
                                                  snapshot.data.docs != null &&
                                                  snapshot.data.docs.length >=
                                                      1)
                                              ? Text(
                                                  '$sentTime',
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.kDefaultPadding / 3,
                                      ),
                                      (snapshot.data != null &&
                                              snapshot.data.docs != null &&
                                              snapshot.data.docs.length >= 1)
                                          ? RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                  text: lastMsgSenderName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                  children: [
                                                    snapshot.data.docs[0]
                                                                ['type'] ==
                                                            'text'
                                                        ? TextSpan(
                                                            text:
                                                                ': ${snapshot.data.docs[0]['message']}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!,
                                                          )
                                                        : snapshot.data.docs[0]
                                                                    ['type'] ==
                                                                'pdf'
                                                            ? TextSpan(
                                                                children: const [
                                                                    TextSpan(
                                                                        text:
                                                                            ': '),
                                                                    WidgetSpan(
                                                                        child:
                                                                            Icon(
                                                                      Icons
                                                                          .file_copy_rounded,
                                                                      color: AppColors
                                                                          .grey,
                                                                      size: 14,
                                                                    )),
                                                                    TextSpan(
                                                                        text:
                                                                            ' PDF')
                                                                  ],
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall)
                                                            : snapshot.data.docs[0]
                                                                        [
                                                                        'type'] ==
                                                                    'img'
                                                                ? TextSpan(
                                                                    children: const [
                                                                        TextSpan(
                                                                            text:
                                                                                ': '),
                                                                        WidgetSpan(
                                                                            child:
                                                                                Icon(
                                                                          Icons
                                                                              .camera_alt_rounded,
                                                                          color:
                                                                              AppColors.grey,
                                                                          size:
                                                                              16,
                                                                        )),
                                                                        TextSpan(
                                                                            text:
                                                                                ' Photo')
                                                                      ],
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bodySmall)
                                                                : TextSpan(
                                                                    text:
                                                                        ' ${snapshot.data.docs[0]['message']}',
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bodySmall),
                                                    //TextSpan(),
                                                  ]))
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: AppSizes.kDefaultPadding / 2,
                                      ),
                                      SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MembersStackOnGroup(
                                              groupId: groupId,
                                            ),
                                            (snapshot.data != null &&
                                                    snapshot.data.docs != null &&
                                                    snapshot.data.docs.length >=
                                                        1)
                                                ? snapshot.data.docs[0]
                                                            ['sendBy'] !=
                                                        FirebaseProvider
                                                            .auth
                                                            .currentUser!
                                                            .displayName
                                                    ? snapshot.data.docs[0]
                                                                ['type'] !=
                                                            'notify'
                                                        ? isSeenByUser == false
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 10,
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.9)),
                                                              )
                                                            : const SizedBox()
                                                        : const SizedBox()
                                                    : const SizedBox()
                                                : const SizedBox()
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 74),
                          child: CustomDivider(),
                        )
                      ],
                    ),
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}

///-----Members Stack Widget on home chat card widget-----///
class MembersStackOnGroup extends StatelessWidget {
  final String groupId;

  const MembersStackOnGroup({Key? key, required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots();

    List<dynamic> membersList = [];

    return SizedBox(
      height: 30,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator.adaptive();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  membersList = snapshot.data?['members'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                              itemCount: membersList.length < 3
                                  ? membersList.length
                                  : 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Align(
                                      widthFactor: 0.3,
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: AppColors.white,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.cardCornerRadius * 10),
                                          child: CachedNetworkImage(
                                            width: 26,
                                            height: 26,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                '${membersList[index]['profile_picture']}',
                                            placeholder: (context, url) =>
                                                const CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  AppColors.shimmer,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  AppColors.shimmer,
                                              child: Text(
                                                membersList[index]['name']
                                                    .substring(0, 1),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          membersList.length > 3
                              ? Align(
                                  widthFactor: 0.6,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.lightGrey,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.white,
                                      child: FittedBox(
                                        child: Text(
                                          '+${membersList.length - 3}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: AppColors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ],
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}
