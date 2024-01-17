import 'package:flutter/material.dart';
import 'package:sekopercinta/components/home_components/home_about.dart';
import 'package:sekopercinta/components/home_components/home_header.dart';
import 'package:sekopercinta/components/home_components/home_inspiration.dart';
import 'package:sekopercinta/utils/constants.dart';

class HomePage extends StatelessWidget {
  // final ValueNotifier<int> _activeIndex;
  // HomePage(this._activeIndex);

  HomePage(ValueNotifier<int> selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [HomeHeader()];
        },
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // if (context.read(authProvider).isAuth) HomeProgress(_activeIndex),
              const SizedBox(
                height: 25,
              ),
              HomeAbout(),
              const SizedBox(
                height: 36,
              ),
              HomeInspiration(),
            ],
          ),
        ),
      ),
    );
  }
}
