import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:cpscom_admin/Widgets/responsive.dart';
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
        backgroundColor: AppColors.bg,
        body: Responsive.isMobile(context)
            ? _buildMobileView(context, widget.stateLoaded)
            : Responsive.isDesktop(context)
                ? _buildDesktopView(context, widget.stateLoaded)
                : _buildTabView(context, widget.stateLoaded));
  }
}

Widget _buildDesktopView(BuildContext context, GetStartedStateLoaded state) {
  return Scaffold(
    backgroundColor: AppColors.lightGrey,
    body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.16,
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(gradient: AppColors.buttonGradientColor),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: AppSizes.kDefaultPadding * 2),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
                  decoration: const BoxDecoration(
                      color: AppColors.shimmer,
                      image: DecorationImage(
                          image: AssetImage(AppImages.welcomeBg),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high)),
                  child: const Image(image: AssetImage(AppImages.welcomeImage)),
                ),
              ),
              Container(
                width: 1,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: AppColors.lightGrey),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.kDefaultPadding * 2,
                      horizontal: AppSizes.kDefaultPadding * 3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            state.responseGetStarted.data?.cms?.title
                                    .toString() ??
                                'Join the Conversation: Connect and Collaborate',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: AppSizes.kDefaultPadding * 2,
                          ),
                          Text(
                            state.responseGetStarted.data?.cms?.description
                                    .toString() ??
                                'Say goodbye to scattered conversations! Connect with your team, share files, and stay organized all in one place.',
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding * 5,
                      ),
                      FullButton(
                          label: 'Get Started',
                          onPressed: () {
                            context.push(const LoginScreen());
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTabView(BuildContext context, GetStartedStateLoaded state) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.welcomeBg),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high)),
          child: const Image(image: AssetImage(AppImages.welcomeImage)),
        ),
      ),
      Container(
        width: 1,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: AppColors.lightGrey),
      ),
      Expanded(
        flex: 2,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.kDefaultPadding * 2,
              horizontal: AppSizes.kDefaultPadding * 3),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    state.responseGetStarted.data?.cms?.title.toString() ??
                        'Join the Conversation: Connect and Collaborate',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding * 2,
                  ),
                  Text(
                    state.responseGetStarted.data?.cms?.description
                            .toString() ??
                        'Say goodbye to scattered conversations! Connect with your team, share files, and stay organized all in one place.',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 5,
              ),
              FullButton(
                  label: 'Get Started',
                  onPressed: () {
                    context.push(const LoginScreen());
                  })
            ],
          ),
        ),
      )
    ],
  );
}

Widget _buildMobileView(BuildContext context, GetStartedStateLoaded state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.welcomeBg),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high)),
          child: const Image(image: AssetImage(AppImages.welcomeImage)),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.kDefaultPadding * 2,
            horizontal: AppSizes.kDefaultPadding * 3),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(12, -12),
                  blurRadius: 15,
                  color: AppColors.lightGrey),
              BoxShadow(
                  offset: Offset(0, 0), blurRadius: 0, color: AppColors.white)
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppSizes.cardCornerRadius),
                topLeft: Radius.circular(AppSizes.cardCornerRadius))),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              Text(
                state.responseGetStarted.data?.cms?.title.toString() ??
                    'Join the Conversation: Connect and Collaborate',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              Text(
                state.responseGetStarted.data?.cms?.description.toString() ??
                    'Say goodbye to scattered conversations! Connect with your team, share files, and stay organized all in one place.',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 4,
              ),
              FullButton(
                  label: 'Get Started',
                  onPressed: () {
                    //preference.setIsFirstTimeAppLoaded(false);
                    context.push(const LoginScreen());
                  }),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 3,
              ),
            ],
          ),
        ),
      )
    ],
  );
}
