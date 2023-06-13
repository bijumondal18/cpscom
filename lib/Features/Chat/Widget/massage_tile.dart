import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:flutter/material.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class MassageTile extends StatelessWidget {
  final Map<String, dynamic> chatMap;

  const MassageTile({Key? key, required this.chatMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Builder(builder: (_) {
      if (chatMap['type'] == 'text') {
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chatMap['sendBy'] ==
                    FirebaseProvider.auth.currentUser!.displayName
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(05.0),
                child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 170),
                    // alignment: Alignment.center,
                    margin: chatMap['sendBy'] ==
                            FirebaseProvider.auth.currentUser!.displayName
                        ? const EdgeInsets.only(left: 06)
                        : const EdgeInsets.only(right: 06),
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 09, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: chatMap['sendBy'] ==
                              FirebaseProvider.auth.currentUser!.displayName
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))
                          : const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                      gradient: chatMap['sendBy'] ==
                              FirebaseProvider.auth.currentUser!.displayName
                          ? const LinearGradient(colors: [
                              Color.fromRGBO(0, 192, 255, 1),
                              Color.fromRGBO(85, 88, 255, 1)
                            ])
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white]),
                    ),
                    child: Align(
                      alignment: chatMap['sendBy'] ==
                              FirebaseProvider.auth.currentUser!.displayName
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: chatMap['sendBy'] ==
                                FirebaseProvider.auth.currentUser!.displayName
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatMap['sendBy'],
                            style: chatMap['sendBy'] ==
                                    FirebaseProvider
                                        .auth.currentUser!.displayName
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.white)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: AppColors.white),
                          ),
                          SizedBox(
                            height: size.height / 200,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.kDefaultPadding),
                            child: Text(
                              chatMap['message'],
                              // textAlign: Alignment.centerLeft,
                              style: chatMap['sendBy'] ==
                                      FirebaseProvider
                                          .auth.currentUser!.displayName
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: AppColors.white)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Column(
                crossAxisAlignment: chatMap['sendBy'] ==
                        FirebaseProvider.auth.currentUser!.displayName
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   DateFormat('hh:mm a').format(date),
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 5,
                  ),
                  chatMap['isSeen'] == true
                      ? const Icon(
                          Icons.done_all,
                          color: Colors.blue,
                          size: 15,
                        )
                      : const Icon(
                          Icons.done,
                          color: Colors.grey,
                          size: 15,
                        ),
                ],
              ),
            ],
          ),
        );
      } else if (chatMap['type'] == "Notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: AppColors.white),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
