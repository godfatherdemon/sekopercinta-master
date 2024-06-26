import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/course_list_item.dart';
import 'package:sekopercinta_master/components/custom_app_bar/custom_tab_indocator.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/course_pages/course_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/classes.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:showcaseview/showcaseview.dart';

class CourseList extends HookWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final classes = useProvider(classWatcher);

    final tabController = useTabController(initialLength: 2);
    final activeIndex = useState(0);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        context.read(moduleProvider).state = "Dasar";
      });
      return;
    }, []);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        tabController.addListener(() {
          activeIndex.value = tabController.index;
        });

        context
            .read(classProvider.notifier)
            .getClasses(context.read(hasuraClientProvider).state)
            .then((_) {
          isLoading.value = false;

          if (context.read(authProvider.notifier).isFirstTimeAccessCourse()) {
            ShowCaseWidget.of(context)
                .startShowCase([CourseTipKeys.courseTipKey1]);
          }
        });
      });

      return;
    }, [activeIndex.value]);

    return Column(
      children: [
        Card(
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                indicatorColor: primaryColor,
                indicator: const MD2Indicator(
                  indicatorSize: MD2IndicatorSize.full,
                  indicatorHeight: 4.0,
                  indicatorColor: primaryColor,
                ),
                labelStyle: Theme.of(context).textTheme.titleMedium,
                unselectedLabelColor: primaryBlack,
                labelColor: primaryColor,
                controller: tabController,
                onTap: (val) {
                  context.read(moduleProvider).state =
                      val == 0 ? 'Dasar' : 'Tematik';
                  activeIndex.value = val;
                  isLoading.value = true;
                },
                tabs: [
                  Tab(
                    iconMargin: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ic-mark.png',
                          color: activeIndex.value == 0
                              ? primaryColor
                              : primaryBlack,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Dasar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: activeIndex.value == 0
                                      ? primaryColor
                                      : primaryBlack,
                                  fontWeight: activeIndex.value == 0
                                      ? FontWeight.w500
                                      : FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    iconMargin: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ic-mark.png',
                          color: activeIndex.value == 1
                              ? primaryColor
                              : primaryBlack,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Tematik',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: activeIndex.value == 1
                                      ? primaryColor
                                      : primaryBlack,
                                  fontWeight: activeIndex.value == 1
                                      ? FontWeight.w500
                                      : FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        isLoading.value
            ? ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => const ShimmerCard(
                  height: 272,
                  width: double.infinity,
                  borderRadius: 10,
                ),
                separatorBuilder: (context, index) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -50,
                      right: -86,
                      child: Image.asset(
                        'assets/images/bg-blur.png',
                        color: primaryColor,
                        width: 191,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
                itemCount: 5,
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: classes.length,
                itemBuilder: (context, index) => CourseListItem(
                    classes[index], classes[index == 0 ? 0 : index - 1], index),
                separatorBuilder: (context, index) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -50,
                      right: -86,
                      child: Image.asset(
                        'assets/images/bg-blur.png',
                        color: primaryColor,
                        width: 191,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
