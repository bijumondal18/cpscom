import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../Chat/Widget/sender_tile.dart';

class MessageInfoScreen extends StatefulWidget {
  final Map<String, dynamic> chatMap;

  const MessageInfoScreen({super.key, required this.chatMap});

  @override
  State<MessageInfoScreen> createState() => _MessageInfoScreenState();
}

class _MessageInfoScreenState extends State<MessageInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Message Info',
      ),
      body: Column(
        children: [
          SenderTile(
            message: widget.chatMap['message'],
            messageType: widget.chatMap['type'],
            sentTime: '',
            groupCreatedBy: '',
            read: '',
            isSeen: widget.chatMap['isSeen'],
          ),
          const SizedBox(
            height: AppSizes.kDefaultPadding,
          ),
          const CustomDivider(),
          Container(
            color: AppColors.shimmer,
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            child: Row(
              children: [
                const Icon(
                  Icons.done_all,
                  size: 20,
                  color: AppColors.grey,
                ),
                const SizedBox(
                  width: AppSizes.kDefaultPadding,
                ),
                Text(
                  'Delivered To'.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          const CustomDivider(),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.only(top: AppSizes.kDefaultPadding / 2),
                itemCount: widget.chatMap['members'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.kDefaultPadding,
                        vertical: AppSizes.kDefaultPadding / 3),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.shimmer,
                          foregroundImage: NetworkImage(widget
                              .chatMap['members'][index]['profile_picture']
                              .toString()),
                        ),
                        const SizedBox(
                          width: AppSizes.kDefaultPadding,
                        ),
                        Text(
                          widget.chatMap['members'][index]['name'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 64),
                    child: CustomDivider(),
                  );
                },
              )),
          const CustomDivider(),
          Container(
            color: AppColors.shimmer,
            padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
            child: Row(
              children: [
                const Icon(
                  Icons.done_all,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  width: AppSizes.kDefaultPadding,
                ),
                Text(
                  'Read By'.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}
