import 'dart:async';

import 'package:flutter/material.dart';

enum PanelShape { rectangle, rounded }

enum DockType { inside, outside }

enum PanelState { open, closed }

class FloatBoxPanel extends StatefulWidget {
  final Widget child;
  final double positionTop;
  final double positionLeft;
  final double width;
  final double height;
  final double panelOpenOffset;
  final DockType dockType;
  final double dockOffset;
  final int dockAnimDuration;
  final Curve dockAnimCurve;
  final Function onPressed;
  final ScrollController scrollController;

  const FloatBoxPanel({
    super.key,
    required this.child,
    required this.positionTop,
    required this.positionLeft,
    required this.width,
    required this.height,
    required this.panelOpenOffset,
    required this.dockType,
    required this.dockOffset,
    required this.dockAnimCurve,
    required this.dockAnimDuration,
    required this.onPressed,
    required this.scrollController,
  });

  @override
  _FloatBoxState createState() => _FloatBoxState();
}

class _FloatBoxState extends State<FloatBoxPanel> {
  // Required to set the default state to closed when the widget gets initialized;
  // PanelState _panelState = PanelState.closed;
  late Timer timer;

  // Width and height of page is required for the dragging the panel;
  double _pageWidth = 0.0;
  double _pageHeight = 0.0;

  // Dock offset creates the boundary for the page depending on the DockType;
  double _dockOffset = 20.0;

  // Widget size if the width of the panel;
  double _widgetWidth = 70.0;
  double _widgetHeight = 70.0;

  // Default positions for the panel;
  double _positionTop = 0.0;
  double _positionLeft = 0.0;

  // ** PanOffset ** is used to calculate the distance from the edge of the panel
  // to the cursor, to calculate the position when being dragged;
  double _panOffsetTop = 0.0;
  double _panOffsetLeft = 0.0;

  // This is the animation duration for the panel movement, it's required to
  // dynamically change the speed depending on what the panel is being used for.
  // e.g: When panel opened or closed, the position should change in a different
  // speed than when the panel is being dragged;
  int _movementSpeed = 0;

  @override
  void initState() {
    _positionTop = widget.positionTop;
    _positionLeft = widget.positionLeft;

    widget.scrollController.position.isScrollingNotifier.addListener(() {
      if (!widget.scrollController.position.isScrollingNotifier.value) {
        timer = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            // _panelState = PanelState.open;

            // Set the left side position;
            _positionLeft = _openDockLeft();
          });
        });
      } else {
        timer.cancel();
        setState(() {
          // _panelState = PanelState.closed;

          // Reset panel position, dock it to nearest edge;
          _forceDock();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // **** METHODS ****

  // Dock boundary is calculated according to the dock offset and dock type.
  double _dockBoundary() {
    if (widget.dockType == DockType.inside) {
      // If it's an 'inside' type dock, dock offset will remain the same;
      return _dockOffset;
    } else {
      // If it's an 'outside' type dock, dock offset will be inverted, hence
      // negative value;
      return -_dockOffset;
    }
  }

  // Dock Left position when open;
  double _openDockLeft() {
    if (_positionLeft < (_pageWidth / 2)) {
      // If panel is docked to the left;
      return widget.panelOpenOffset;
    } else {
      // If panel is docked to the right;
      return ((_pageWidth - _widgetWidth)) - (widget.panelOpenOffset);
    }
  }

  // Force dock will dock the panel to it's nearest edge of the screen;
  void _forceDock() {
    // Calculate the center of the panel;
    double center = _positionLeft + (_widgetWidth / 2);

    // Set movement speed to the custom duration property or '300' default;
    _movementSpeed = widget.dockAnimDuration;

    // Check if the position of center of the panel is less than half of the
    // page;
    if (center < _pageWidth / 2) {
      // Dock to the left edge;
      _positionLeft = 0.0 + _dockBoundary();
    } else {
      // Dock to the right edge;
      _positionLeft = (_pageWidth - _widgetWidth) - _dockBoundary();
    }
  }

  void _defaultDock() {
    // Calculate the center of the panel;
    double center = _positionLeft + (_widgetWidth / 2);

    // Set movement speed to the custom duration property or '300' default;
    _movementSpeed = widget.dockAnimDuration;

    // Check if the position of center of the panel is less than half of the
    // page;
    if (center < _pageWidth / 2) {
      // Dock to the left edge;
      _positionLeft = widget.panelOpenOffset;
    } else {
      // Dock to the right edge;
      _positionLeft = ((_pageWidth - _widgetWidth)) - (widget.panelOpenOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Width and height of page is required for the dragging the panel;
    _pageWidth = MediaQuery.of(context).size.width;
    _pageHeight = MediaQuery.of(context).size.height;

    // Dock offset creates the boundary for the page depending on the DockType;
    _dockOffset = widget.dockOffset;

    // Widget size if the width of the panel;
    _widgetWidth = widget.width;
    _widgetHeight = widget.height;

    // Animated positioned widget can be moved to any part of the screen with
    // animation;
    return AnimatedPositioned(
      duration: Duration(
        milliseconds: _movementSpeed,
      ),
      top: _positionTop,
      left: _positionLeft,
      // curve: widget.dockAnimCurve ?? Curves.fastLinearToSlowEaseIn,
      curve: widget.dockAnimCurve,

      // Animated Container is used for easier animation of container height;
      child: SizedBox(
        width: _widgetWidth,
        height: _widgetHeight,
        child: GestureDetector(
          onPanEnd: (event) {
            setState(
              () {
                _defaultDock();
              },
            );
          },
          onPanStart: (event) {
            // Detect the offset between the top and left side of the panel and
            // x and y position of the touch(click) event;
            _panOffsetTop = event.globalPosition.dy - _positionTop;
            _panOffsetLeft = event.globalPosition.dx - _positionLeft;
          },
          onPanUpdate: (event) {
            setState(
              () {
                // Close Panel if opened;
                // _panelState = PanelState.closed;

                // Reset Movement Speed;
                _movementSpeed = 0;

                // Calculate the top position of the panel according to pan;
                _positionTop = event.globalPosition.dy - _panOffsetTop;

                // Check if the top position is exceeding the dock boundaries;
                if (_positionTop < 0) {
                  _positionTop = 0;
                }
                if (_positionTop > _pageHeight - (_widgetHeight + 120)) {
                  _positionTop = _pageHeight - (_widgetHeight + 120);
                }

                // Calculate the Left position of the panel according to pan;
                _positionLeft = event.globalPosition.dx - _panOffsetLeft;

                // Check if the left position is exceeding the dock boundaries;
                if (_positionLeft < 0 + _dockBoundary()) {
                  _positionLeft = 0 + _dockBoundary();
                }
                if (_positionLeft >
                    (_pageWidth - _widgetWidth) - _dockBoundary()) {
                  _positionLeft = (_pageWidth - _widgetWidth) - _dockBoundary();
                }
              },
            );
          },
          // onTap: widget.onPressed,
          onTap: () {
            widget.onPressed();
          },

          child: widget.child,
        ),
      ),
    );
  }
}
