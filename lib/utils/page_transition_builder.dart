import 'package:flutter/material.dart';

Route createRoute(
    {required Widget page, bool isVertical = false, dynamic arguments}) {
  return PageRouteBuilder(
    settings: RouteSettings(arguments: arguments),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = isVertical ? const Offset(0.0, 1.0) : const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
