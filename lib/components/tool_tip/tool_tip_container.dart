import 'package:flutter/material.dart';
import 'package:sekopercinta_master/page/course_pages/course_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:showcaseview/showcaseview.dart';

class ToolTipContainer extends StatelessWidget {
  // final GlobalKey key;
  final String title;
  final String description;
  final int step;
  // final Function? onButtonTap;
  final Function()? onButtonTap;
  final Widget child;

  const ToolTipContainer({
    super.key,
    // required this.key,
    required this.title,
    required this.description,
    required this.step,
    required this.onButtonTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      // key: step == 1
      //     ? CourseTipKeys.courseTipKey1
      //     : step == 2
      //         ? CourseTipKeys.courseTipKey2
      //         : step == 3
      //             ? CourseTipKeys.courseTipKey3
      //             : null as GlobalKey<State<StatefulWidget>>?,
      key: step == 1
          ? CourseTipKeys.courseTipKey1
          : step == 2
              ? CourseTipKeys.courseTipKey2
              : step == 3
                  ? CourseTipKeys.courseTipKey3
                  // ignore: cast_from_null_always_fails
                  : null as GlobalKey<State<StatefulWidget>>,
      height: 136,
      width: MediaQuery.of(context).size.width - 40,
      overlayOpacity: 0.20,
      disposeOnTap: false,
      container: Container(
        height: 136,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/ic-info-tool-tip.png',
                      width: 28,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Tooltip(
                        message: description,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: accentColor
                                      .withOpacity(step >= 2 ? 1 : 0.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: accentColor
                                      .withOpacity(step >= 3 ? 1 : 0.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 36,
                            width: 80,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => accentColor,
                                ),
                              ),
                              // onPressed: onButtonTap,
                              // onPressed: () => onButtonTap(),
                              // onPressed: onButtonTap?.call,
                              onPressed: onButtonTap ?? () {},
                              child: Text(
                                step == 3 ? 'Selesai' : 'Lanjut',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      child: child,
    );
  }
}
