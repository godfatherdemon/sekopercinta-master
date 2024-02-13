import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/audio_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/video_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/string_extension.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

import 'course_activity/doucment_read_activity/document_activity_page.dart';
import 'course_activity/activity_briefing_page.dart';

class CourseActiveTab extends HookWidget {
  final Pelajaran? lesson;

  CourseActiveTab(this.lesson);
  @override
  Widget build(BuildContext context) {
    final _activity = useProvider(activityProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Silabus',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryVeryDarkColor,
                    ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Matri pelajaran dan aktivitas modul ini',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            lesson == null
                ? ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      return ShimmerCard(
                          height: 80, width: double.infinity, borderRadius: 12);
                    },
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemCount: _activity.length,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      final activityType = _activity[index].jenisAktivitas;
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shadowColor: index == 0
                            ? secondaryColor.withOpacity(0.24)
                            : _activity[index - 1].progresAktivitas.isEmpty
                                ? Colors.transparent
                                : _activity[index - 1]
                                            .progresAktivitas[0]
                                            .progres <
                                        1
                                    ? Colors.transparent
                                    : secondaryColor.withOpacity(0.24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: index == 0
                                  ? Colors.transparent
                                  : _activity[index - 1]
                                          .progresAktivitas
                                          .isEmpty
                                      ? Color(0xFFF0EDEB)
                                      : _activity[index - 1]
                                                  .progresAktivitas[0]
                                                  .progres <
                                              1
                                          ? Color(0xFFF0EDEB)
                                          : Colors.transparent),
                        ),
                        color: index == 0
                            ? primaryWhite
                            : _activity[index - 1].progresAktivitas.isEmpty
                                ? brokenWhite
                                : _activity[index - 1]
                                            .progresAktivitas[0]
                                            .progres <
                                        1
                                    ? brokenWhite
                                    : primaryWhite,
                        child: InkWell(
                          onTap: () async {
                            if (index > 0) {
                              if (_activity[index - 1]
                                  .progresAktivitas
                                  .isEmpty) {
                                return;
                              }

                              if (_activity[index - 1]
                                      .progresAktivitas[0]
                                      .progres <
                                  1) {
                                return;
                              }
                            }
                            switch (activityType) {
                              case 'video':
                                await Navigator.of(context).push(createRoute(
                                    page: VideoPage(
                                  id: _activity[index].idAktivitas,
                                  progressAktivitas:
                                      _activity[index].progresAktivitas,
                                )));
                                break;
                              case 'audio':
                                await Navigator.of(context).push(createRoute(
                                    page: AudioPage(
                                  id: _activity[index].idAktivitas,
                                  title: _activity[index].namaAktivitas,
                                  progressAktivitas:
                                      _activity[index].progresAktivitas,
                                )));
                                break;
                              case 'article':
                                await Navigator.of(context).push(createRoute(
                                    page: DocumentActivityPage(
                                  id: _activity[index].idAktivitas,
                                  aktivitas: _activity[index],
                                )));
                                break;
                              default:
                                Navigator.of(context).push(createRoute(
                                  page: ActivityBriefingPage(
                                    activity: _activity[index],
                                  ),
                                ));
                                break;
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: index == 0
                                      ? BoxDecoration(
                                          gradient: activityType == 'video' ||
                                                  activityType == 'audio'
                                              ? gradientD
                                              : activityType == 'article'
                                                  ? gradientB
                                                  : gradientC,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        )
                                      : _activity[index - 1]
                                              .progresAktivitas
                                              .isEmpty
                                          ? BoxDecoration(
                                              color: Color(0xFFE7E4E2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )
                                          : _activity[index - 1]
                                                      .progresAktivitas[0]
                                                      .progres <
                                                  1
                                              ? BoxDecoration(
                                                  color: Color(0xFFE7E4E2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                )
                                              : BoxDecoration(
                                                  gradient:
                                                      activityType == 'video' ||
                                                              activityType ==
                                                                  'audio'
                                                          ? gradientD
                                                          : activityType ==
                                                                  'article'
                                                              ? gradientB
                                                              : gradientC,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                  child: Center(
                                    child: activityType == 'video'
                                        ? Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                'assets/images/ic-play.png',
                                                width: 9.8,
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            activityType == 'audio'
                                                ? 'assets/images/ic-audio.png'
                                                : activityType == 'article'
                                                    ? 'assets/images/ic-docs.png'
                                                    : 'assets/images/ic-games.png',
                                            width: 32,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _activity[index].namaAktivitas,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        (_activity[index]
                                                .sumberAktivitas
                                                .isNotEmpty)
                                            ? '${_activity[index].sumberAktivitas[0].durasiKonten}'
                                            : 'Aktivitas ${activityType.capitalizeFirstOfEach}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      if (_activity[index]
                                          .progresAktivitas
                                          .isNotEmpty)
                                        _activity[index]
                                                    .progresAktivitas[0]
                                                    .progres ==
                                                1
                                            ? Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/ic-check.png',
                                                    width: 12,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Pelajaran Telah Selesai',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color:
                                                              primaryDarkColor,
                                                        ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      child:
                                                          LinearProgressIndicator(
                                                        minHeight: 4,
                                                        value: _activity[index]
                                                            .progresAktivitas[0]
                                                            .progres,
                                                        backgroundColor:
                                                            primaryDarkColor
                                                                .withOpacity(
                                                                    0.2),
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                primaryDarkColor),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 22,
                                                  ),
                                                  Text(
                                                    '${(_activity[index].progresAktivitas[0].progres * 100).toStringAsFixed(0)} %',
                                                  ),
                                                ],
                                              ),
                                      if (_activity[index]
                                          .progresAktivitas
                                          .isEmpty)
                                        Text(
                                          index == 0
                                              ? 'Mulai Pelajaran Sekarang'
                                              : _activity[index - 1]
                                                          .progresAktivitas
                                                          .isNotEmpty &&
                                                      _activity[index - 1]
                                                              .progresAktivitas[
                                                                  0]
                                                              .progres ==
                                                          1
                                                  ? 'Mulai Pelajaran Sekarang'
                                                  : 'Pelajaran belum dimulai',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: index == 0
                                                    ? accentColor
                                                    : _activity[index - 1]
                                                                .progresAktivitas
                                                                .isNotEmpty &&
                                                            _activity[index - 1]
                                                                    .progresAktivitas[
                                                                        0]
                                                                    .progres ==
                                                                1
                                                        ? accentColor
                                                        : primaryGrey,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
