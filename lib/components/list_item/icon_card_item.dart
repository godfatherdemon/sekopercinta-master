import 'package:flutter/material.dart';

class IconItemCard extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;
  final double width;
  final double height;

  const IconItemCard({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/bg-pattern-icon.png',
          ),
        ),
      ),
      child: Center(child: child),
    );
  }
}
