import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final GetStartedStateLoaded stateLoaded;

  const WelcomeScreen({Key? key, required this.stateLoaded}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AppPreference preference = AppPreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shimmer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Image(
                  image: const AssetImage(AppImages.welcomeBg),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.60,
                ),
                Positioned(
                  left: 40,
                  right: 40,
                  child: Image(
                    image: const AssetImage(AppImages.welcomeImage),
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.60,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.kDefaultPadding * 2,
                  horizontal: AppSizes.kDefaultPadding * 3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.lightGrey, width: 1.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(-8, -8),
                        blurRadius: 15,
                        color: AppColors.lightGrey)
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppSizes.cardCornerRadius * 2),
                      topLeft: Radius.circular(AppSizes.cardCornerRadius * 2))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.stateLoaded.responseGetStarted.data?.cms?.title
                                .toString() ??
                            'Join the Conversation: Connect and Collaborate',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Text(
                        widget.stateLoaded.responseGetStarted.data?.cms
                                ?.description
                                .toString() ??
                            'Say goodbye to scattered conversations! Connect with your team, share files, and stay organized all in one place.',
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  FullButton(
                      label: 'Get Started',
                      onPressed: () {
                        preference.setIsFirstTimeAppLoaded(false);
                        context.push(const LoginScreen());
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
