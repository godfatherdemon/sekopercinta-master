import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/course_components/exit_activity_bottom_sheet.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class ActivityHeader extends StatelessWidget {
  final double progress;
  final String activityName;

  const ActivityHeader({
    super.key,
    required this.progress,
    required this.activityName,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final isExit = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExitActivityBottomSheet(activityName),
                ),
              );

              if (isExit == null) {
                return;
              }

              if (isExit) {
                // Navigator.of(context).pop();
                navigator.pop('context');
              }
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/ic-games-outlined.png',
                      width: 22.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sedang beraktivitas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.5),
                            ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        activityName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.white.withOpacity(0.25),
                          value: progress,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
