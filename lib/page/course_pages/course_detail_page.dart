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
  @override
  Widget build(BuildContext context) {
    final _courseId = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['id'];
    final _modul = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['modul'];
    final _index = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['index'];
    final _tabIndex = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['tab_index'];
    final bool _isLastLessons = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['isLastLessons'];
    // final String _lessonImage = (ModalRoute.of(context)?.settings.arguments
    //     as Map<String, dynamic>)['lesson_image'];
    final String? _lessonImage = (ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>)['lesson_image'];

    final _lessonData = useState<Pelajaran?>(null);
    final _isLoading = useState(false);

    final _tabController =
        useTabController(initialLength: 4, initialIndex: _tabIndex);
    final _activeIndex = useState(0);

    final _totalSecond = useState(0);
    final _totalMinute = useState(0);
    final _totalDuration = useState<String>('00:00:00');
    final _totalArticle = useState(0);
    final _totalActivityGames = useState(0);

    final _getActivity = useMemoized(
        () => () async {
              await context.read(lessonProvider.notifier).getLessons(
                    context.read(hasuraClientProvider).state,
                    _courseId,
                    _isLastLessons,
                  );

              _lessonData.value = context.read(lessonProvider);
            },
        []);

    useEffect(
      () {
        _tabController.addListener(() {
          _activeIndex.value = _tabController.index;
        });
        _isLoading.value = true;
        _getActivity().then((value) {
          _isLoading.value = false;

          for (var lesson in _lessonData.value!.aktivitas) {
            if (lesson.jenisAktivitas == 'article') {
              _totalArticle.value++;
            } else if (lesson.jenisAktivitas == 'audio' ||
                lesson.jenisAktivitas == 'video') {
              final time = DateTime.parse(
                  '2012-02-27 ${lesson.sumberAktivitas[0].durasiKonten}');
              _totalSecond.value = _totalSecond.value + time.second;
              _totalMinute.value = _totalMinute.value + time.minute;
              // _totalDuration.value.add(Duration(hours: ))
            } else {
              _totalActivityGames.value++;
            }
          }

          _totalDuration.value = '${_totalMinute.value}:${_totalSecond.value}';
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
                  icon: Icon(
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              flexibleSpace: Hero(
                // tag: _lessonImage,
                tag: _lessonImage ?? 'defaultTagValue',
                child: Container(
                  height: 330.0,
                  decoration: BoxDecoration(
                    gradient: _index == 0
                        ? gradientA
                        : _index == 1
                            ? gradientB
                            : _index == 2
                                ? gradientC
                                : gradientD,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
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
                                        'Modul $_modul',
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
                                      _lessonData.value == null
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
                                              _lessonData.value!.namaPelajaran,
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
                                            '${_totalDuration.value} Menit Audio Visual',
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
                                            '${_totalArticle.value} Materi Bacaan',
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
                                            '${_totalActivityGames.value} Aktivitas',
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
                            child: _lessonImage != null
                                ? Image.network(
                                    _lessonImage,
                                    width: 200,
                                    height: 200,
                                  )
                                : SizedBox(),
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
                    indicator: MD2Indicator(
                      indicatorSize: MD2IndicatorSize.normal,
                      indicatorHeight: 4.0,
                      indicatorColor: primaryColor,
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    labelColor: primaryColor,
                    unselectedLabelColor: primaryBlack,
                    controller: _tabController,
                    isScrollable: true,
                    physics: BouncingScrollPhysics(),
                    tabs: [
                      Tab(
                        iconMargin: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ic-mark.png',
                              color: _activeIndex.value == 0
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
                                      color: _activeIndex.value == 0
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: _activeIndex.value == 0
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
                              color: _activeIndex.value == 1
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
                                      color: _activeIndex.value == 1
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: _activeIndex.value == 1
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
                              color: _activeIndex.value == 2
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
                                      color: _activeIndex.value == 2
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: _activeIndex.value == 2
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
                              color: _activeIndex.value == 3
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
                                      color: _activeIndex.value == 3
                                          ? primaryColor
                                          : primaryBlack,
                                      fontWeight: _activeIndex.value == 3
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
          controller: _tabController,
          physics: BouncingScrollPhysics(),
          children: [
            CourseIntroductionTab(_lessonData.value!),
            CourseActiveTab(_lessonData.value!),
            CourseAttachmentTab(),
            CourseDiscussionTab(_lessonData.value!),
          ],
        ),
      ),
    );
  }
}
