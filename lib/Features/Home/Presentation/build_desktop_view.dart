// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cpscom_admin/Commons/commons.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
//
// import '../../../Api/firebase_provider.dart';
// import '../../Chat/Presentation/chat_screen.dart';
// import '../../MyProfile/Presentation/my_profile_screen.dart';
// import 'home_screen.dart';
//
// class BuildDesktopView extends StatefulWidget {
//   const BuildDesktopView({Key? key}) : super(key: key);
//
//   @override
//   State<BuildDesktopView> createState() => _BuildDesktopViewState();
// }
//
// class _BuildDesktopViewState extends State<BuildDesktopView> {
//   var future = FirebaseProvider.firestore
//       .collection('users')
//       .doc(FirebaseProvider.auth.currentUser!.uid)
//       .get();
//
//   bool? isAdmin;
//   int? selectedIndex;
//
//   final FirebaseProvider firebaseProvider = FirebaseProvider();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrey,
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.16,
//             width: MediaQuery.of(context).size.width,
//             decoration:
//                 const BoxDecoration(gradient: AppColors.buttonGradientColor),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.1,
//                 vertical: AppSizes.kDefaultPadding * 2),
//             decoration: const BoxDecoration(
//               color: AppColors.white,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: AppSizes.appBarHeight,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: AppSizes.kDefaultPadding),
//                         decoration: const BoxDecoration(color: AppColors.bg),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             StreamBuilder(
//                                 stream:
//                                     firebaseProvider.getCurrentUserDetails(),
//                                 builder: (context,
//                                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                                   switch (snapshot.connectionState) {
//                                     case ConnectionState.none:
//                                     case ConnectionState.waiting:
//                                       return const CircularProgressIndicator
//                                           .adaptive();
//                                     default:
//                                       if (snapshot.hasData) {
//                                         // bool isAdmin = snapshot.data?['isAdmin'];
//                                         return GestureDetector(
//                                           onTap: () => context
//                                               .push(const MyProfileScreen()),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                                 AppSizes.cardCornerRadius * 10),
//                                             child: CachedNetworkImage(
//                                                 width: 34,
//                                                 height: 34,
//                                                 fit: BoxFit.cover,
//                                                 imageUrl:
//                                                     '${snapshot.data?['profile_picture']}',
//                                                 placeholder: (context, url) =>
//                                                     const CircleAvatar(
//                                                       radius: 16,
//                                                       backgroundColor:
//                                                           AppColors.bg,
//                                                     ),
//                                                 errorWidget: (context, url,
//                                                         error) =>
//                                                     CircleAvatar(
//                                                       radius: 16,
//                                                       backgroundColor:
//                                                           AppColors.bg,
//                                                       child: Text(
//                                                         snapshot.data!['name']
//                                                             .substring(0, 1)
//                                                             .toString()
//                                                             .toUpperCase(),
//                                                         style: Theme.of(context)
//                                                             .textTheme
//                                                             .bodyText1!
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600),
//                                                       ),
//                                                     )),
//                                           ),
//                                         );
//                                       }
//                                   }
//                                   return const SizedBox();
//                                 }),
//                             PopupMenuButton(
//                               position: PopupMenuPosition.under,
//                               icon: const Icon(
//                                 EvaIcons.moreVerticalOutline,
//                                 size: 22,
//                                 color: AppColors.darkGrey,
//                               ),
//                               itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                     value: 1,
//                                     child: Text(
//                                       'New Group',
//                                       style:
//                                           Theme.of(context).textTheme.bodyText2,
//                                     )),
//                                 PopupMenuItem(
//                                     value: 1,
//                                     child: Text(
//                                       'Logout',
//                                       style:
//                                           Theme.of(context).textTheme.bodyText2,
//                                     )),
//                               ],
//                               onSelected: (value) {
//                                 switch (value) {
//                                   case 1:
//                                     // context.push(ChangeGroupTitle(
//                                     //   groupId: widget.groupId,
//                                     // ));
//                                     break;
//                                 }
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                       Expanded(child: BuildChatList(isAdmin: isAdmin ?? false))
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 1,
//                   height: MediaQuery.of(context).size.height,
//                   decoration: const BoxDecoration(color: AppColors.lightGrey),
//                 ),
//                 // Expanded(
//                 //   flex: 6,
//                 //   child: Container(
//                 //     color: AppColors.bg,
//                 //     child: ChatScreen(
//                 //       groupId: '',
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
