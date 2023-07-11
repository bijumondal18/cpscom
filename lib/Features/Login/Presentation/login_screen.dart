import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Bloc/login_bloc.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Commons/app_images.dart';
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
      child: Responsive.isMobile(context)
          ? _buildMobileView(context)
          : Responsive.isTablet(context)
              ? _buildTabletView(context)
              : _buildDesktopView(context),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              AppIcons.appLogo,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: AppSizes.kDefaultPadding / 2,
            ),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding / 2,
              ),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 6,
              ),
              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Email Address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 2,
              ),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid Password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 6,
              ),
              BlocProvider(
                create: (context) => LoginBloc(),
                child: BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginStateLoaded) {
                      context.pushAndRemoveUntil(const HomeScreen());
                    }
                    if (state is LoginStateFailed) {
                      customSnackBar(
                        context,
                        state.errorMsg,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
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
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              // TextButton(
              //     style: TextButton.styleFrom(
              //       minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
              //     ),
              //     onPressed: () {},
              //     child: Text(
              //       'Forgot Password?',
              //       style: Theme.of(context).textTheme.bodyMedium,
              //     ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletView(BuildContext context) {
    return Scaffold(
      body: Row(
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
              child: Image(
                image: const AssetImage(AppImages.welcomeImage),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.appLogo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  Container(
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
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding / 2,
                        ),
                        Text(
                          'Sign in to continue',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 6,
                        ),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Email Address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 2,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 6,
                        ),
                        BlocProvider(
                          create: (context) => LoginBloc(),
                          child: BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginStateLoaded) {
                                context.pushAndRemoveUntil(const HomeScreen());
                              }
                              if (state is LoginStateFailed) {
                                customSnackBar(
                                  context,
                                  state.errorMsg,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is LoginStateLoading) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                              if (state is LoginStateInitial) {
                                return FullButton(
                                    label: 'Login',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<LoginBloc>(context).add(
                                            LoginSubmittedEvent(
                                                email:
                                                    emailController.text.trim(),
                                                password: passwordController
                                                    .text
                                                    .trim()));
                                      }
                                      return null;
                                    });
                              }
                              return Container();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding,
                        ),
                        // TextButton(
                        //     style: TextButton.styleFrom(
                        //       minimumSize:
                        //           const Size.fromHeight(AppSizes.buttonHeight),
                        //     ),
                        //     onPressed: () {},
                        //     child: Text(
                        //       'Forgot Password?',
                        //       style: Theme.of(context).textTheme.bodyMedium,
                        //     ))
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
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
                    child: Image(
                      image: const AssetImage(AppImages.welcomeImage),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.appLogo,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding,
                        ),
                        Container(
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
                              Text(
                                'Welcome Back!',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: AppSizes.kDefaultPadding / 2,
                              ),
                              Text(
                                'Sign in to continue',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: AppSizes.kDefaultPadding * 6,
                              ),
                              CustomTextField(
                                controller: emailController,
                                hintText: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid Email Address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: AppSizes.kDefaultPadding * 2,
                              ),
                              CustomTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid Password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: AppSizes.kDefaultPadding * 6,
                              ),
                              BlocProvider(
                                create: (context) => LoginBloc(),
                                child: BlocConsumer<LoginBloc, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginStateLoaded) {
                                      context.pushAndRemoveUntil(
                                          const HomeScreen());
                                    }
                                    if (state is LoginStateFailed) {
                                      customSnackBar(
                                        context,
                                        state.errorMsg,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoginStateLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      );
                                    }
                                    if (state is LoginStateInitial) {
                                      return FullButton(
                                          label: 'Login',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(LoginSubmittedEvent(
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim()));
                                            }
                                            return null;
                                          });
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: AppSizes.kDefaultPadding,
                              ),
                              // TextButton(
                              //     style: TextButton.styleFrom(
                              //       minimumSize: const Size.fromHeight(
                              //           AppSizes.buttonHeight),
                              //     ),
                              //     onPressed: () {},
                              //     child: Text(
                              //       'Forgot Password?',
                              //       style: Theme.of(context).textTheme.bodyMedium,
                              //     ))
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
