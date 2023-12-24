<<<<<<< Updated upstream
import 'package:cpscom_admin/Features/ReportScreen/Bloc/user_report_bloc.dart';
=======
import 'package:cpscom_admin/Features/GroupInfo/Bloc/image_upload_bloc.dart';
import 'package:cpscom_admin/Features/Home/Repository/groups_repository.dart';
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          BlocProvider(create: (_) => UserReportBloc()),
          BlocProvider(create: (_) => UserMentionCubit()),
=======
          //BlocProvider(create: (_) => ImageUploadBloc()),
          //BlocProvider(create: (_) => GroupBloc(groupsRepository: GroupsRepository())..add(const LoadGroups({'uid':'NSXX7LbApfcMFafWio2QdQ0xeGhzWaiyQwQ1'}))),
>>>>>>> Stashed changes
        ],
        child: child);
  }
}
