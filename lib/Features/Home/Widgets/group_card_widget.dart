// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// import '../../../Commons/app_colors.dart';
// import '../../../Commons/app_sizes.dart';
//
// class GroupCardWidget extends StatelessWidget {
//   final String imageUrl;
//   final String groupName;
//   final String lastMsg;
//   final String sentTime;
//   final VoidCallback onPressed;
//
//   const GroupCardWidget(
//       {Key? key,
//       required this.imageUrl,
//       required this.groupName,
//       required this.lastMsg,
//       required this.sentTime,
//       required this.onPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: true,
//       horizontalTitleGap: AppSizes.kDefaultPadding,
//       contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding, vertical: AppSizes.kDefaultPadding/2),
//       onTap: onPressed,
//       leading: ClipRRect(
//         borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 10),
//         child: CachedNetworkImage(
//           imageUrl: imageUrl,
//           fit: BoxFit.cover,
//           width: 50,
//           height: 50,
//           placeholder: (context, url) => const CircleAvatar(
//             radius: 50,
//             backgroundColor: AppColors.shimmer,
//           ),
//           errorWidget: (context, url, error) => CircleAvatar(
//             radius: 50,
//             backgroundColor: AppColors.shimmer,
//             child: Text(
//               groupName.substring(0, 1).toString().toUpperCase(),
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyText1!
//                   .copyWith(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ),
//       title: Text(
//         groupName,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: Theme.of(context).textTheme.bodyLarge,
//       ),
//       subtitle: Text(
//         lastMsg,
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//         style: Theme.of(context).textTheme.bodySmall,
//       ),
//       trailing: Column(
//         children: [
//           Text(
//             sentTime,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(context).textTheme.bodySmall,
//           ),
//         ],
//       ),
//     );
//   }
// }
