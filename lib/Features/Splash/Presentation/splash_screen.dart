import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Welcome/Presentation/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppPreference preference = AppPreference();

  @override
  void initState() {
    context.read<GetStartedBloc>().add(GetStartedSubmittedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GetStartedBloc, GetStartedState>(
        listener: (context, state) async {
          if (state is GetStartedStateLoaded) {
            if (await preference.isLoggedIn() == true) {
              context.pushReplacement(const HomeScreen());
            } else {
              context.pushReplacement(WelcomeScreen(
                stateLoaded: state,
              ));
              //context.pushReplacement(const LoginScreen());
            }
          }
          if (state is GetStartedStateFailed) {}
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.appLogo,
                  width: 90,
                  height: 90,
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
