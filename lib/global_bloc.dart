import 'package:cpscom_admin/Features/ReportScreen/Bloc/user_report_bloc.dart';
import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
import 'package:cpscom_admin/Utils/cubit/user_mention_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GlobalBloc extends StatelessWidget {
  final Widget child;

  const GlobalBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GetStartedBloc()),
          BlocProvider(create: (_) => UserReportBloc()),
          BlocProvider(create: (_) => UserMentionCubit()),
        ],
        child: child);
  }
}
