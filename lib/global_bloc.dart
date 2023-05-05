import 'package:cpscom_admin/Features/Home/Repository/groups_repository.dart';
import 'package:cpscom_admin/Features/Splash/Bloc/get_started_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Features/Home/Bloc/group_bloc.dart';

class GlobalBloc extends StatelessWidget {
  final Widget child;

  const GlobalBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GetStartedBloc()),
          BlocProvider(create: (_) => GroupBloc(groupsRepository: GroupsRepository())..add(LoadGroups({'uid':'NSXX7LbApfcMFafWio2QdQ0xeGhzWaiyQwQ1'}))),
        ],
        child: child);
  }
}
