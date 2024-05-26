import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color color;
  final Color highlightColor;

  const ShimmerCard({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.color = const Color(0xFFE3E7EA),
    this.highlightColor = const Color(0xFFF5F5F5),
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: const Color(0xFFE3E7EA),
        ),
      ),
    );
  }
}
