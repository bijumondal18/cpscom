import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
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
        ],
        child: child);
  }
}
