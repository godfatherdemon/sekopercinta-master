import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/answer_many_instruction.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/answer_many_questions.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/answer_many_statement.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/flip_card_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/finish_activity_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/loading_activity_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class AnswerManyPage extends HookWidget {
  final Aktivitas activity;
  const AnswerManyPage({super.key, required this.activity});
  @override
  Widget build(BuildContext context) {
    final listKey = useState(GlobalKey<AnimatedListState>());
    final isLoading = useState(true);
    final widgets = useState<List<Widget>>([]);
    final isStart = useState(false);
    final currentQuestion = useState(0);
    final questions = useState<List<Pertanyaan>>([]);
    final answer = useState<List<String>>([]);

    final finishQuestion = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);

              if (!(currentQuestion.value < questions.value.length - 1)) {
                widgets.value[0] = FlipCardHeader(
                  isStart,
                  1,
                  activity.namaAktivitas,
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

                widgets.value[1] = SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
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

                for (int i = 0; i < answer.value.length; i++) {
                  Map<String, String> object = {
                    'isi_jawaban': answer.value[i],
                    'id_pertanyaan': questions.value[0].idPertanyaan,
                  };

                  objects.add(object);
                }

                var answers = answer.value.toString().replaceFirst('[', '{');

                // print(answers.length);
                final Logger logger = Logger();
                logger.d(answers.length);

                answers = answers.replaceRange(answers.length - 1, null, '}');

                await context.read(questionProvider.notifier).giveAnswerMany(
                      context.read(hasuraClientProvider).state,
                      answers,
                      questions.value[0].idPertanyaan,
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
                  questions: questions.value,
                )));
              }
            },
        []);

    final startActivity = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);

              // await Future.delayed(Duration(milliseconds: 700));

              isStart.value = false;
              widgets.value[0] = FlipCardHeader(
                  isStart,
                  currentQuestion.value / questions.value.length,
                  activity.namaAktivitas);
              widgets.value[2] = AnswerManyQuestions(
                isStart: isStart,
                answers: answer,
                finish: finishQuestion,
              );

              widgets.value[1] = AnswerManyStatement(
                  isStart, questions.value[0].isiPertanyaan);
              isStart.value = true;

              listKey.value.currentState?.removeItem(
                2,
                (context, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: widgets.value[2],
                  );
                },
                duration: Duration.zero,
              );

              await Future.delayed(const Duration(milliseconds: 500));

              listKey.value.currentState?.insertItem(
                2,
                duration: duration,
              );
            },
        []);

    final showQuestion = useMemoized(
        () => () async {
              const duration = Duration(milliseconds: 500);
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

              widgets.value[1] = AnswerManyStatement(
                  isStart, questions.value[0].isiPertanyaan);
              widgets.value[2] = Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: FillButton(
                  text: 'Mulai',
                  color: Colors.white,
                  textColor: accentColor,
                  onTap: () {
                    startActivity();
                  },
                  leading: Container(),
                ),
              );

              listKey.value.currentState?.insertItem(
                1,
                duration: duration,
              );

              listKey.value.currentState?.insertItem(
                2,
                duration: duration,
              );
            },
        []);

    final initialAnimation = useMemoized(
        () => () async {
              for (int i = 0; i < widgets.value.length; i++) {
                listKey.value.currentState?.insertItem(
                  i,
                  duration: i == 0 || i == 2
                      ? Duration.zero
                      : const Duration(milliseconds: 500),
                );

                if (i != 0 && i != 2) {
                  await Future.delayed(const Duration(
                    milliseconds: 700,
                  ));
                }
              }
            },
        []);

    useEffect(() {
      context
          .read(questionProvider.notifier)
          .getQuestions(
              hasuraConnect: context.read(hasuraClientProvider).state,
              id: activity.idAktivitas)
          .then((value) {
        questions.value = context.read(questionProvider);

        widgets.value = [
          FlipCardHeader(
              isStart,
              currentQuestion.value / questions.value.length,
              questions.value[0].isiPertanyaan),
          const AnswerManyInstruction(),
          AnswerManyQuestions(
            isStart: isStart,
            answers: answer,
            finish: finishQuestion,
          ),
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
