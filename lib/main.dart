import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sekopercinta/page/auth_pages/on_boarding_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('sekopercinta');
  runApp(ProviderScope(child: MyApp()));
}

// void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Sekoper Cinta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: accentColor,
        hintColor: accentColor,
        primaryColorDark: accentColor,
        primaryColorLight: accentColor,
        primarySwatch: Colors.deepPurple,
        textTheme: mainTextTheme,
        fontFamily: 'Biennale',
      ),
      navigatorKey: navigatorKey,
      home: MainPage(),
    );
  }
}

class MainPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final authState = context.read(authProvider.notifier);
    return authState.tryAutoLogin()
        ? BottomNavPage()
        : authState.isFirstTimeUsingApp()
            ? OnBoardingPage()
            : BottomNavPage();
  }
}
