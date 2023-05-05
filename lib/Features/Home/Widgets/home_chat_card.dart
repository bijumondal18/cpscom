import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeChatCard extends StatelessWidget {
  final String groupName;
  final String? groupDesc;
  final String sentTime;
  final String? lastMsg;
  final int? unseenMsgCount;
  final String? imageUrl;
  final VoidCallback onPressed;
  final String groupId;

  const HomeChatCard({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.sentTime,
    required this.onPressed,
    this.groupDesc = '',
    this.imageUrl = '',
    this.lastMsg = '',
    this.unseenMsgCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed.call(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.shimmer,
                  foregroundImage: NetworkImage(imageUrl ?? ''),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                groupName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Text(
                              sentTime,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        groupDesc != ''
                            ? Text(
                                '$groupDesc',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding / 2,
                        ),
                        MembersStackOnGroup(
                          groupId: groupId,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 76),
            child: CustomDivider(),
          )
        ],
      ),
    );
  }
}

class MembersStackOnGroup extends StatelessWidget {
  final String groupId;

  const MembersStackOnGroup({Key? key, required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    var stream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('groups')
        .doc(groupId)
        .snapshots();

    List<dynamic> membersList = [];
    int membersCount;

    return SizedBox(
      height: 30,
      child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (snapshot.hasData) {
                  membersList = snapshot.data!['members'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                              itemCount: membersList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                membersCount = membersList.length;
                                return Align(
                                    widthFactor: 0.5,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: AppColors.white,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.shimmer,
                                        backgroundImage: NetworkImage(
                                          "${AppStrings.imagePath}${membersList[index]['profile_picture']}",
                                        ),
                                      ),
                                    ));
                              }),
                          // Align(
                          //   widthFactor: 0.5,
                          //   child: CircleAvatar(
                          //     radius: 14,
                          //     backgroundColor: AppColors.white,
                          //     child: CircleAvatar(
                          //       radius: 12,
                          //       backgroundColor: AppColors.lightGrey,
                          //       child: Text(
                          //         membersCount > 3
                          //             ? '+${membersCount - 3}'
                          //             : '',
                          //         style: Theme.of(context).textTheme.caption,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // unseenMsgCount != null
                      //     ? CircleAvatar(
                      //         radius: 10,
                      //         backgroundColor: AppColors.primary,
                      //         child: Text(
                      //           '$unseenMsgCount',
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .caption!
                      //               .copyWith(color: AppColors.white),
                      //         ),
                      //       )
                      //     : Container()
                    ],
                  );
                }
            }
            return const SizedBox();
          }),
    );
  }
}
