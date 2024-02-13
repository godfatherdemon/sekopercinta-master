import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/floating_widget/floating_panel.dart';

class FloatingButtonFacilitator extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final double width;
  final double height;
  final ScrollController scrollController;

  FloatingButtonFacilitator({
    required this.onTap,
    required this.child,
    required this.width,
    required this.height,
    required this.scrollController,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FloatBoxPanel(
      positionLeft: size.width - (width + 10),
      positionTop: size.height - (height + 120),
      scrollController: scrollController,
      dockType: DockType.inside,
      dockOffset: -40.0,
      dockAnimDuration: 300,
      dockAnimCurve: Curves.easeOut,
      panelOpenOffset: 10.0,
      width: width,
      height: height,
      child: child,
      onPressed: onTap,
    );
  }
}
