import 'package:cached_network_image/cached_network_image.dart';
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
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                  child: CachedNetworkImage(
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    imageUrl: '$imageUrl',
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                      child: Text(
                        groupName.substring(0, 1),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
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
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$groupDesc',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  // unseenMsgCount != null
                                  //?
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.primary,
                                    child: FittedBox(
                                      child: Text(
                                        '4',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  )
                                  // : const SizedBox()
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding / 2,
                        ),
                        // MembersStackOnGroup(
                        //   groupId: groupId,
                        // )
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
//
// class MembersStackOnGroup extends StatelessWidget {
//   final String groupId;
//
//   const MembersStackOnGroup({Key? key, required this.groupId})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var indx;
//     var stream = FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('groups')
//         .doc(groupId)
//         .snapshots();
//
//     List<dynamic> membersList = [];
//
//     return SizedBox(
//       height: 30,
//       child: StreamBuilder(
//           stream: stream,
//           builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.none:
//               case ConnectionState.waiting:
//               default:
//                 if (snapshot.hasData) {
//                   membersList = snapshot.data!['members'];
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           ListView.builder(
//                               itemCount: membersList.length,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 indx = membersList.length;
//                                 //membersCount = membersList.length;
//                                 if (indx > 3) {
//                                   return Row(
//                                     children: [
//                                       Align(
//                                         widthFactor: 0.3,
//                                         child: CircleAvatar(
//                                           radius: 32,
//                                           backgroundColor: AppColors.white,
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                                 AppSizes.cardCornerRadius * 10),
//                                             child: CachedNetworkImage(
//                                               width: 26,
//                                               height: 26,
//                                               fit: BoxFit.cover,
//                                               imageUrl:
//                                                   '${AppStrings.imagePath}${membersList[index]['profile_picture']}',
//                                               placeholder: (context, url) =>
//                                                   const CircleAvatar(
//                                                 radius: 26,
//                                                 backgroundColor:
//                                                     AppColors.shimmer,
//                                               ),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       CircleAvatar(
//                                                 radius: 26,
//                                                 backgroundColor:
//                                                     AppColors.shimmer,
//                                                 child: Text(
//                                                   membersList[index]
//                                                           ['name']
//                                                       .substring(0, 1),
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyText1!
//                                                       .copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w600),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                      indx== membersList.length-1?Align(
//                                         widthFactor: 0.5,
//                                         child: CircleAvatar(
//                                           radius: 14,
//                                           backgroundColor: AppColors.white,
//                                           child: CircleAvatar(
//                                             radius: 12,
//                                             backgroundColor:
//                                                 AppColors.lightGrey,
//                                             child: Text(
//                                               membersList.length > 3
//                                                   ? '+${membersList.length - 3}'
//                                                   : '',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .caption,
//                                             ),
//                                           ),
//                                         ),
//                                       ): const SizedBox(),
//                                     ],
//                                   );
//                                 }else{
//                                   Align(
//                                     widthFactor: 0.3,
//                                     child: CircleAvatar(
//                                       radius: 32,
//                                       backgroundColor: AppColors.white,
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(
//                                             AppSizes.cardCornerRadius * 10),
//                                         child: CachedNetworkImage(
//                                           width: 26,
//                                           height: 26,
//                                           fit: BoxFit.cover,
//                                           imageUrl:
//                                           '${AppStrings.imagePath}${membersList[index]['profile_picture']}',
//                                           placeholder: (context, url) =>
//                                           const CircleAvatar(
//                                             radius: 26,
//                                             backgroundColor:
//                                             AppColors.shimmer,
//                                           ),
//                                           errorWidget:
//                                               (context, url, error) =>
//                                               CircleAvatar(
//                                                 radius: 26,
//                                                 backgroundColor:
//                                                 AppColors.shimmer,
//                                                 child: Text(
//                                                   snapshot.data!['members']
//                                                   ['name']
//                                                       .substring(0, 1),
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyText1!
//                                                       .copyWith(
//                                                       fontWeight:
//                                                       FontWeight.w600),
//                                                 ),
//                                               ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               }),
//                         ],
//                       ),
//                       // unseenMsgCount != null
//                       //     ? CircleAvatar(
//                       //         radius: 10,
//                       //         backgroundColor: AppColors.primary,
//                       //         child: Text(
//                       //           '$unseenMsgCount',
//                       //           style: Theme.of(context)
//                       //               .textTheme
//                       //               .caption!
//                       //               .copyWith(color: AppColors.white),
//                       //         ),
//                       //       )
//                       //     : Container()
//                     ],
//                   );
//                 }
//             }
//             return const SizedBox();
//           }),
//     );
//   }
// }
