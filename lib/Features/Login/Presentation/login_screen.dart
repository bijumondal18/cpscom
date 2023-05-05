import 'dart:io';

import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Bloc/login_bloc.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Widgets/full_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage(
                      AppIcons.appLogo,
                    ),
                    width: 90,
                    fit: BoxFit.contain,
                    height: 90,
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding * 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email Address',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid Email Address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500),
                              )),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding * 2,
                  ),
                  BlocProvider(
                    create: (context) => LoginBloc(),
                    child: BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginStateLoaded) {
                          context.push(const HomeScreen());
                        }
                        if (state is LoginStateFailed) {
                          customSnackBar(
                              context, state.errorMsg, AppColors.error);
                        }
                      },
                      builder: (context, state) {
                        if (state is LoginStateLoading) {
                          return Center(
                            child: Platform.isAndroid
                                ? const CircularProgressIndicator(
                                    color: AppColors.primary,
                                  )
                                : const CupertinoActivityIndicator(),
                          );
                        }
                        if (state is LoginStateInitial) {
                          return FullButton(
                              label: 'Login',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginBloc>(context).add(
                                      LoginSubmittedEvent(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim()));
                                }
                                return null;
                              });
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
