import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/activity_header.dart';

class FlipCardHeader extends HookWidget {
  final ValueNotifier<bool> isStart;
  final double progress;
  final String activityName;

  FlipCardHeader(this.isStart, this.progress, this.activityName);
  @override
  Widget build(BuildContext context) {
    print(isStart.value);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          SizeTransition(child: child, sizeFactor: animation),
      child: isStart.value
          ? Container(
              key: ValueKey<bool>(true),
              child: ActivityHeader(
                progress: progress,
                activityName: activityName,
              ),
            )
          : Container(
              key: ValueKey<bool>(false),
            ),
    );
  }
}
