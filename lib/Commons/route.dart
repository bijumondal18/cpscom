import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;

  CustomPageRoute({required this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.linear;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
}

extension CustomNavigator on BuildContext {
  Future<dynamic> push(Widget page) async {
    Navigator.of(this, rootNavigator: true).push(CupertinoPageRoute(
        // fullscreenDialog: true,
        maintainState: true,
        builder: (_) => page));

    // Navigator.push(this, CupertinoPageRoute(
    //     fullscreenDialog: true,
    //     builder: (_) => page));
  }

  //clear current navigation stack
  Future<dynamic> pushReplacement(Widget page) async {
    Navigator.of(this, rootNavigator: true).pushReplacement(CupertinoPageRoute(
        // fullscreenDialog: true,
        maintainState: true,
        builder: (_) => page));

    // Navigator.pushReplacement(this, CupertinoPageRoute(
    //     fullscreenDialog: true,
    //     builder: (_) => page));
  }

  //clear all the navigation history stack
  Future<dynamic> pushAndRemoveUntil(Widget page) async {
    Navigator.of(this, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute(
            //fullscreenDialog: true,
            maintainState: true,
            builder: (_) => page),
        (route) => false);

    // Navigator.pushAndRemoveUntil(this, CupertinoPageRoute(
    //   fullscreenDialog: true,
    //   builder: (_) => page,),(route)=> false);
  }

  void pop(Widget page, [result]) async {
    return Navigator.of(this).pop(result);
  }
}
