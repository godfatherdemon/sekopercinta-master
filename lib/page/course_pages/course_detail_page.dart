import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_app_bar/custom_tab_indocator.dart';
import 'package:sekopercinta_master/components/custom_app_bar/presistent_header.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity_tab.dart';
import 'package:sekopercinta_master/page/course_pages/course_attachment_tab.dart';
import 'package:sekopercinta_master/page/course_pages/course_introduction_tab.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

import 'course_discussion/course_discussion_tab.dart';

class CourseDetailPage extends HookWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseId = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['id'];
    final modul = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['modul'];
    final index = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['index'];
    final tabIndex = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['tab_index'];
    final bool isLastLessons = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['isLastLessons'];
    // final String _lessonImage = (ModalRoute.of(context)?.settings.arguments
    //     as Map<String, dynamic>)['lesson_image'];
    final String? lessonImage = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['lesson_image'];

    final lessonData = useState<Pelajaran?>(null);
    final isLoading = useState(false);

    final tabController =
        useTabController(initialLength: 4, initialIndex: tabIndex);
    final activeIndex = useState(0);

    final totalSecond = useState(0);
    final totalMinute = useState(0);
    final totalDuration = useState<String>('00:00:00');
    final totalArticle = useState(0);
    final totalActivityGames = useState(0);

    final getActivity = useMemoized(
        () => () async {
              await context.read(lessonProvider.notifier).getLessons(
                    context.read(hasuraClientProvider).state,
                    courseId,
                    isLastLessons,
                  );

              // lessonData.value = context.read(lessonProvider);
              lessonData.value = lessonProvider as Pelajaran?;
            },
        []);

    useEffect(
      () {
        tabController.addListener(() {
          activeIndex.value = tabController.index;
        });
        isLoading.value = true;
        getActivity().then((value) {
          isLoading.value = false;

          for (var lesson in lessonData.value!.aktivitas) {
            if (lesson.jenisAktivitas == 'article') {
              totalArticle.value++;
            } else if (lesson.jenisAktivitas == 'audio' ||
                lesson.jenisAktivitas == 'video') {
              final time = DateTime.parse(
                  '2012-02-27 ${lesson.sumberAktivitas[0].durasiKonten}');
              totalSecond.value = totalSecond.value + time.second;
              totalMinute.value = totalMinute.value + time.minute;
              // _totalDuration.value.add(Duration(hours: ))
            } else {
              totalActivityGames.value++;
            }
          }

          totalDuration.value = '${totalMinute.value}:${totalSecond.value}';
        });

        return;
      },
      [],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text(
                'Detail Course',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              leading: Tooltip(
                message: 'Back',
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              elevation: 0,
              pinned: true,
              centerTitle: true,
              expandedHeight: 310.0,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              flexibleSpace: Hero(
                // tag: _lessonImage,
                tag: lessonImage ?? 'defaultTagValue',
                child: Container(
                  height: 330.0,
                  decoration: BoxDecoration(
                    gradient: index == 0
                        ? gradientA
                        : index == 1
                            ? gradientB
                            : index == 2
                                ? gradientC
                                : gradientD,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                height: 280,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Modul $modul',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      lessonData.value == null
                                          ? ShimmerCard(
                                              height: 68,
                                              width: double.infinity,
                                              borderRadius: 0,
                                              color: backgroundColor
                                                  .withOpacity(0.1),
                                              highlightColor: backgroundColor
                                                  .withOpacity(0.2),
                                            )
                                          : Text(
                                              lessonData.value!.namaPelajaran,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic-play-vid.png',
                                            width: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '${totalDuration.value} Menit Audio Visual',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic-games-outlined.png',
                                            color: Colors.white,
                                            width: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '${totalArticle.value} Materi Bacaan',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic-games-outlined.png',
                                            color: Colors.white,
                                            width: 16,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '${totalActivityGames.value} Aktivitas',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Image.asset('assets/images/bg-card-2.png'),
                          ),
                          Positioned(
                            bottom: -40,
                            right: -40,
                            child: lessonImage != null
                                ? Image.network(
                                    lessonImage,
                                    width: 200,
                                    height: 200,
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    indicator: const MD2Indicator(
                      indicatorSize: MD2IndicatorSize.normal,
                      indicatorHeight: 4.0,
                      indicatorColor: primaryColor,
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    labelColor: primaryColor,
                    unselectedLabelColor: primaryBlack,
                    controller: tabController,
                    isScrollable: true,
                    physics: const BouncingScrollPhysics(),
                    tabs: [
                      Tab(
                        iconMargin: const EdgeInsets.all(0),
                        child: Row(
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
                              'Pengantar',
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
                          children: [
                            Image.asset(
                              'assets/images/ic-games-outlined.png',
                              color: activeIndex.value == 1
                                  ? primaryColor
                                  : primaryBlack,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Aktivitas',
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
                      Tab(
                        iconMargin: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ic-mark.png',
                              color: activeIndex.value == 2
                                  ? primaryColor
                                  : primaryBlack,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Lampiran',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: activeIndex.value == 2
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: activeIndex.value == 2
                                          ? FontWeight.w500
                                          : FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        iconMargin: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ic-discuss.png',
                              color: activeIndex.value == 3
                                  ? primaryColor
                                  : primaryBlack,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Diskusi',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: activeIndex.value == 3
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: activeIndex.value == 3
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
          ];
        },
        body: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            CourseIntroductionTab(lessonData.value!),
            CourseActiveTab(lessonData.value!),
            const CourseAttachmentTab(),
            CourseDiscussionTab(lessonData.value!),
          ],
        ),
      ),
    );
  }
}
