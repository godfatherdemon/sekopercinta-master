import 'package:flutter/material.dart';

enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class MD2Indicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final MD2IndicatorSize indicatorSize;

  const MD2Indicator(
      {required this.indicatorHeight,
      required this.indicatorColor,
      required this.indicatorSize});

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

class _MD2Painter extends BoxPainter {
  final MD2Indicator decoration;
  // final double width = 100.0; // replace with your actual width
  // final double height = 50.0; // replace with your actual height

  // Rect rect = Rect.fromLTWH(0, 0, width, height);

  _MD2Painter(this.decoration, VoidCallback onChanged)
      // : assert(decoration != null),
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // assert(configuration != null);
    assert(configuration.size != null);
    double width = 100.0;
    double height = 50.0;

    // Paint paint = Paint();

    Rect rect = Rect.fromLTWH(0, 0, width, height);

    // Rect rect;
    // if (decoration.indicatorSize == MD2IndicatorSize.full) {
    //   rect = Offset(offset.dx,
    //           (configuration.size!.height - decoration.indicatorHeight)) &
    //       Size(configuration.size!.width, decoration.indicatorHeight);
    // } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
    //   rect = Offset(offset.dx + 6,
    //           (configuration.size!.height - decoration.indicatorHeight)) &
    //       Size(configuration.size!.width - 12, decoration.indicatorHeight);
    // } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
    //   rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
    //           (configuration.size!.height - decoration.indicatorHeight)) &
    //       Size(16, decoration.indicatorHeight);
    // }

    // final Paint paint = Paint();
    // paint.color = decoration.indicatorColor ?? Color(0xff1967d2);
    // paint.color = decoration.indicatorColor;

    final Paint paint = Paint()
      ..color = decoration.indicatorColor
      ..style = PaintingStyle.fill;

    // paint.style = PaintingStyle.fill;

    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(rect,
    //         topRight: Radius.circular(8), topLeft: Radius.circular(8)),
    //     paint);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(8),
        topLeft: const Radius.circular(8),
      ),
      paint,
    );
  }
}
