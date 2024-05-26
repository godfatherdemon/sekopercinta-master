import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/activity_header.dart';

class FlipCardHeader extends HookWidget {
  final ValueNotifier<bool> isStart;
  final double progress;
  final String activityName;

  const FlipCardHeader(this.isStart, this.progress, this.activityName,
      {super.key});
  @override
  Widget build(BuildContext context) {
    // print(isStart.value);
    final Logger logger = Logger();
    logger.d(isStart.value);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          SizeTransition(sizeFactor: animation, child: child),
      child: isStart.value
          ? Container(
              key: const ValueKey<bool>(true),
              child: ActivityHeader(
                progress: progress,
                activityName: activityName,
              ),
            )
          : Container(
              key: const ValueKey<bool>(false),
            ),
    );
  }
}
