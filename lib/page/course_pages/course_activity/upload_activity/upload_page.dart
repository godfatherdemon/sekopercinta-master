import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/activity_header.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/questions_card.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/upload_card.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/upload_instruction.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/loading_activity_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

import '../finish_activity_page.dart';

class UploadPage extends HookWidget {
  final Aktivitas activity;
  const UploadPage({super.key, required this.activity});
  @override
  Widget build(BuildContext context) {
    final listKey = useState(GlobalKey<AnimatedListState>());
    final isLoading = useState(true);
    final widgets = useState<List<Widget>>([]);
    final currentQuestion = useState(0);
    final questions = useState<List<String>>([]);
    final answer = useState<List<String>>([]);
    final selectedFile = useState<File?>(null);

    final nextQuestion = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);

              if (currentQuestion.value < questions.value.length - 1) {
                currentQuestion.value += 1;

                widgets.value[0] = ActivityHeader(
                  progress: (currentQuestion.value) / questions.value.length,
                  activityName: activity.namaAktivitas,
                );

                listKey.value.currentState?.removeItem(
                  2,
                  (context, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: const Offset(0.0, -0.3),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        )),
                        child: widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(duration);

                widgets.value[1] = QuestionsCard(
                    questions: questions.value,
                    currentQuestions: currentQuestion);

                await Future.delayed(const Duration(milliseconds: 700));

                listKey.value.currentState?.insertItem(
                  2,
                  duration: duration,
                );
              } else {
                widgets.value[0] = ActivityHeader(
                  progress: 1,
                  activityName: activity.namaAktivitas,
                );

                listKey.value.currentState?.removeItem(
                  1,
                  (context, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: const Offset(0.0, -0.3),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        )),
                        child: widgets.value[1],
                      ),
                    );
                  },
                  duration: duration,
                );
                listKey.value.currentState?.removeItem(
                  1,
                  (context, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: const Offset(0.0, -0.3),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        )),
                        child: widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(
                    Duration(milliseconds: duration.inMilliseconds + 200));

                var screenHeight =
                    MediaQueryData.fromView(WidgetsBinding.instance.window)
                        .size
                        .height;
                widgets.value[1] = SizedBox(
                  // height: MediaQuery.of(context).size.height - 150,
                  height: screenHeight - 150,
                  width: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                );

                listKey.value.currentState?.insertItem(
                  1,
                  duration: duration,
                );

                List<Map<String, String>> objects = [];

                for (int i = 0; i < questions.value.length; i++) {
                  Map<String, String> object = {
                    'isi_jawaban': answer.value[i],
                    'id_pertanyaan': questions.value[i],
                  };

                  objects.add(object);
                }

                await context
                    .read(activityProvider.notifier)
                    .sendActivityCommunityImage(
                      file: selectedFile.value!,
                      comment: answer.value[1],
                      hasuraConnect: context.read(hasuraClientProvider).state,
                      id: activity.idAktivitas,
                    );

                await context.read(activityProvider.notifier).updateProgress(
                      context,
                      context.read(hasuraClientProvider).state,
                      activity.idAktivitas,
                      1,
                    );

                Navigator.of(context).pushReplacement(createRoute(
                    page: FinishActivityPage(
                  activity: activity,
                  answers: answer.value,
                  questions: [
                    Pertanyaan(
                      isiPertanyaan: questions.value[0],
                      idPertanyaan: '',
                      kunciJawabanPilgans: [],
                      pilihanJawaban: [],
                    ),
                    Pertanyaan(
                      isiPertanyaan: questions.value[1],
                      idPertanyaan: '',
                      kunciJawabanPilgans: [],
                      pilihanJawaban: [],
                    ),
                  ],
                )));
              }
            },
        []);

    final prevQuestion = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);

              if (currentQuestion.value > 0) {
                listKey.value.currentState?.removeItem(
                  1,
                  (context, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: const Offset(0.0, -0.3),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        )),
                        child: widgets.value[1],
                      ),
                    );
                  },
                  duration: duration,
                );
                listKey.value.currentState?.removeItem(
                  1,
                  (context, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: const Offset(0.0, -0.3),
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        )),
                        child: widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(
                    Duration(milliseconds: duration.inMilliseconds + 200));

                currentQuestion.value -= 1;

                widgets.value[0] = ActivityHeader(
                  progress: (currentQuestion.value) / questions.value.length,
                  activityName: activity.namaAktivitas,
                );

                listKey.value.currentState?.insertItem(
                  1,
                  duration: duration,
                );

                listKey.value.currentState?.insertItem(
                  2,
                  duration: duration,
                );
              }
            },
        []);

    final initialAnimation = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 1000);
              for (int i = 0; i < widgets.value.length; i++) {
                listKey.value.currentState?.insertItem(
                  i,
                  duration:
                      i == 0 ? duration : const Duration(milliseconds: 500),
                );
                await Future.delayed(Duration(
                  milliseconds: i == 0 ? duration.inMilliseconds + 200 : 700,
                ));
              }
            },
        []);

    final showQuestion = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);
              listKey.value.currentState?.removeItem(
                0,
                (context, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        end: Offset.zero,
                        begin: const Offset(0.0, -0.3),
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      )),
                      child: widgets.value[0],
                    ),
                  );
                },
                duration: duration,
              );
              listKey.value.currentState?.removeItem(
                0,
                (context, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        end: Offset.zero,
                        begin: const Offset(0.0, -0.3),
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      )),
                      child: widgets.value[1],
                    ),
                  );
                },
                duration: duration,
              );

              await Future.delayed(
                  Duration(milliseconds: duration.inMilliseconds + 200));

              widgets.value = [
                ActivityHeader(
                  progress: currentQuestion.value / questions.value.length,
                  activityName: activity.namaAktivitas,
                ),
                QuestionsCard(
                  questions: questions.value,
                  currentQuestions: currentQuestion,
                ),
                UploadCard(
                  nextQuestion: nextQuestion,
                  prevQuestion: prevQuestion,
                  saveAnswer: (value) {
                    answer.value.add(value);
                    // print(answer.value);
                    final Logger logger = Logger();
                    logger.d(answer.value);
                  },
                  currentQuestion: currentQuestion,
                  selectedFile: ValueNotifier<File>(
                    selectedFile.value ?? File('default_path'),
                  ),
                ),
              ];

              Future.delayed(const Duration(milliseconds: 200)).then((value) {
                initialAnimation();
              });
            },
        []);

    useEffect(() {
      context
          .read(questionProvider.notifier)
          .getUploadInstruction(
              context.read(hasuraClientProvider).state, activity.idAktivitas)
          .then((value) {
        questions.value = [
          value[0]['instruksi_unggah'],
          value[0]['instruksi_komentar']
        ];
        widgets.value = [
          const UploadInstruction(),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: FillButton(
              text: 'Lanjutkan',
              color: Colors.white,
              textColor: accentColor,
              onTap: () {
                showQuestion();
              },
              leading: Container(),
            ),
          ),
        ];

        Future.delayed(const Duration(milliseconds: 1000)).then((value) {
          isLoading.value = false;

          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            initialAnimation();
          });
        });
      });
      return;
    }, []);

    return isLoading.value
        ? const LoadingActivityPage()
        : Scaffold(
            backgroundColor: accentColor,
            body: SafeArea(
              child: AnimatedList(
                key: listKey.value,
                initialItemCount: 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    key: Key('$index'),
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        end: Offset.zero,
                        begin: const Offset(0.0, -0.1),
                      )),
                      child: widgets.value[index],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
