import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/essay_activity/essay_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/flip_card_activity/flip_card_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/multiple_choice_activity/multiple_choice_many_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/upload_activity/upload_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:sekopercinta_master/utils/string_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'answer_many_activity/answer_many_page.dart';
import 'multiple_choice_activity/multiple_choice_page.dart';

class ActivityBriefingPage extends HookWidget {
  final Aktivitas activity;

  const ActivityBriefingPage({
    super.key,
    required this.activity,
  });
  @override
  Widget build(BuildContext context) {
    final data = useState<String?>(null);
    final totalQuestion = useState<int>(0);

    useEffect(() {
      // print(activity.idAktivitas);
      final Logger logger = Logger();
      logger.d(activity.idAktivitas);
      context
          .read(activityProvider.notifier)
          .getActivityIntroduction(
              context.read(hasuraClientProvider).state, activity.idAktivitas)
          .then((value) {
        data.value = value['isi_pengantar'];
        totalQuestion.value = value['total'];
      });
      return;
    }, []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          children: [
            PopAppBar(
              title: 'Aktivitas',
              action: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Your action logic here
                },
              ),
              onPop: () {
                // Your back button logic here
              },
            ),
            Expanded(
              child: data.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              activity.jenisAktivitas.capitalizeFirstOfEach,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              activity.namaAktivitas,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // Text(
                            //   _data.value,
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),
                            Text(
                              data.value ??
                                  '', // Use an empty string if _data.value is null
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Aktivitas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: primaryVeryDarkColor,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic-games-outlined.png',
                                        width: 20,
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
                                              activity.jenisAktivitas
                                                  .capitalizeFirstOfEach,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color: primaryVeryDarkColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              activity.jenisAktivitas == 'essay'
                                                  ? 'Anda akan menuliskan jawaban anda dari pertanyaan atau pernyataan yang disajikan.'
                                                  : activity.jenisAktivitas ==
                                                              'multichoice' ||
                                                          activity.jenisAktivitas ==
                                                              'multimanychoice'
                                                      ? 'Anda akan menjawab pertanyaan dengan memilih salah satu dari beberapa jawaban yang ditampilkan'
                                                      : activity.jenisAktivitas ==
                                                              'upload'
                                                          ? 'Setelah melakukan praktik, bagikan foto dan ceritakan hasil praktik Anda'
                                                          : activity.jenisAktivitas ==
                                                                  'answermany'
                                                              ? 'Anda akan menjawab pertanyaan yang diberikan kepada anda dengan sebanyak-banyaknya jawaban yang Anda ketahui'
                                                              : 'Anda akan memilih salah satu dari dua pilihan terkait pernyataan yang diberikan ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Divider(
                                    color: Color(0xFF9B6EE5),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic-essay.png',
                                        color: primaryColor,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${activity.jenisAktivitas == 'upload' ? 2 : totalQuestion.value} Pertanyaan',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: primaryVeryDarkColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Divider(
                                    color: Color(0xFF9B6EE5),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic-star.png',
                                        color: primaryColor,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Modul Dasar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: primaryVeryDarkColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 65,
                            ),
                            FillButton(
                              text: 'Mulai Aktivitas',
                              onTap: () async {
                                if (activity.jenisAktivitas == 'essay') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page: EssayPage(activity: activity),
                                    isVertical: true,
                                  ));
                                }
                                if (activity.jenisAktivitas == 'multichoice') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page:
                                        MultipleChoicePage(activity: activity),
                                    isVertical: true,
                                  ));
                                }
                                if (activity.jenisAktivitas ==
                                    'multimanychoice') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page: MultipleChoiceManyPage(
                                        activity: activity),
                                    isVertical: true,
                                  ));
                                }
                                if (activity.jenisAktivitas == 'truefalse') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page: FlipCardPage(
                                      activity: activity,
                                    ),
                                    isVertical: true,
                                  ));
                                }
                                if (activity.jenisAktivitas == 'upload') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page: UploadPage(activity: activity),
                                    isVertical: true,
                                  ));
                                }
                                if (activity.jenisAktivitas == 'answermany') {
                                  Navigator.of(context)
                                      .pushReplacement(createRoute(
                                    page: AnswerManyPage(activity: activity),
                                    isVertical: true,
                                  ));
                                }
                              },
                              leading: Container(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
