import 'package:flutter/material.dart';

const Color primaryWhite = Colors.white;
const Color backgroundColor = Color(0xFFFBFCFE);
const Color brokenWhite = Color(0xFFF9F6F4);
const Color lightGrey = Color(0xFFF0EDEB);
const Color accentColor = Color(0xFF4D4FF1);
const Color primaryColor = Color(0xFF9B6EE5);
const Color primaryDarkColor = Color(0xFF4B2384);
const Color primaryVeryDarkColor = Color(0xFF23195E);
const Color secondaryColor = Color(0xFFFFA8A7);
const Color secondaryDarkColor = Color(0xFFBA3565);
const Color darkBrown = Color(0xFF714253);
const Color primaryBlack = Color(0xFF4E4E4E);
const Color primaryGrey = Color(0xFFA2A1A1);
const Color primaryDarkGrey = Color(0xFF989693);
const Color primaryBlue = Color(0xFF56CCF2);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const LinearGradient gradientPrimary = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xFF8F94F9),
    Color(0xFF4D4FF1),
  ],
);

const LinearGradient gradientA = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xFFF29492),
    Color(0xFFE75C96),
  ],
);

const LinearGradient gradientB = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xFFFFA883),
    Color(0xFFFB607C),
  ],
);

const LinearGradient gradientC = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xFFEEB0BB),
    Color(0xFF7C87EC),
  ],
);

const LinearGradient gradientD = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xFF4C99FF),
    Color(0xFF6574FF),
  ],
);

const List<LinearGradient> gradients = [
  gradientA,
  gradientB,
  gradientC,
  gradientD,
];

const TextTheme mainTextTheme = TextTheme(
  headlineSmall: TextStyle(
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    fontSize: 24,
  ),
  titleLarge: TextStyle(
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    fontSize: 20,
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w500,
    color: primaryBlack,
    fontSize: 16,
  ),
  titleSmall: TextStyle(
    fontWeight: FontWeight.w500,
    color: primaryBlack,
    height: 1.5,
    fontSize: 12,
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w400,
    color: primaryBlack,
    fontSize: 14,
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.w400,
    color: primaryBlack,
    height: 1.5,
    fontSize: 12,
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w400,
    color: primaryBlack,
    fontSize: 10,
  ),
  labelLarge: TextStyle(
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    fontSize: 14,
  ),
);
