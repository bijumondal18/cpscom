import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Models/member_model.dart';
import '../../../Widgets/custom_divider.dart';

class MemberCardWidget extends StatefulWidget {
  final MembersModel member;
  final int index;

  const MemberCardWidget(
      {super.key, required this.member, required this.index});

  @override
  State<MemberCardWidget> createState() => _MemberCardWidgetState();
}

class _MemberCardWidgetState extends State<MemberCardWidget> {
  var selectedIndex = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                  child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    imageUrl: widget.member.profilePicture ?? '',
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.shimmer,
                      child: Text(
                        widget.member.name?.substring(0, 1) ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.kDefaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.member.name ?? '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      widget.member.email ?? '',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            value: selectedIndex.contains(widget.index),
            onChanged: (_) {
              setState(() {
                if (selectedIndex.contains(widget.index)) {
                  selectedIndex.remove(widget.index);
                  //selectedMembers.unique((x) => x['uid']);
                } else {
                  selectedIndex.add(widget.index);
                  // selectedMembers
                  //     .add(members[index].data() as Map<String, dynamic>);
                  // selectedMembers.unique((x) => x['uid']);
                }
              });
            }),
        const Padding(
          padding: EdgeInsets.only(left: 64),
          child: CustomDivider(),
        )
      ],
    );
  }
}
