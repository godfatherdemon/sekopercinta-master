import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/home_components/home_about.dart';
import 'package:sekopercinta_master/components/home_components/home_header.dart';
import 'package:sekopercinta_master/components/home_components/home_inspiration.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class HomePage extends StatelessWidget {
  // final ValueNotifier<int> _activeIndex;
  // HomePage(this._activeIndex);

  const HomePage(ValueNotifier<int> selectedIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [const HomeHeader()];
        },
        body: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // if (context.read(authProvider).isAuth) HomeProgress(_activeIndex),
              SizedBox(
                height: 25,
              ),
              HomeAbout(),
              SizedBox(
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
