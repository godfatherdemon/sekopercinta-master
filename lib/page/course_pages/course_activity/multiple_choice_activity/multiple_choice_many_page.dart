import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/course_components/activity_components/activity_header.dart';
import 'package:sekopercinta/components/course_components/activity_components/multiple_question_card.dart';
import 'package:sekopercinta/components/course_components/activity_components/questions_card.dart';
import 'package:sekopercinta/page/course_pages/course_activity/loading_activity_page.dart';
import 'package:sekopercinta/providers/activities.dart';
import 'package:sekopercinta/providers/questions.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../finish_activity_page.dart';

class MultipleChoiceManyPage extends HookWidget {
  final Aktivitas activity;

  MultipleChoiceManyPage({required this.activity});
  @override
  Widget build(BuildContext context) {
    final _listKey = useState(GlobalKey<AnimatedListState>());
    final _isLoading = useState(true);
    final _widgets = useState<List<Widget>>([]);
    final _currentQuestion = useState(0);
    final _questions = useState<List<Pertanyaan>>([]);
    final _answer = useState<List<String>>([]);

    final _nextQuestion = useMemoized(
        () => (bool choice) async {
              final duration = Duration(milliseconds: 500);

              if (_currentQuestion.value < _questions.value.length - 1) {
                _currentQuestion.value += 1;

                _widgets.value[0] = ActivityHeader(
                  progress: (_currentQuestion.value) / _questions.value.length,
                  activityName: activity.namaAktivitas,
                );

                _listKey.value.currentState?.removeItem(
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
                        child: _widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(duration);

                _widgets.value[1] = QuestionsCard(
                    questions:
                        _questions.value.map((e) => e.isiPertanyaan).toList(),
                    currentQuestions: _currentQuestion);

                await Future.delayed(Duration(milliseconds: 700));

                _listKey.value.currentState?.insertItem(
                  2,
                  duration: duration,
                );
              } else {
                _widgets.value[0] = ActivityHeader(
                  progress: 1,
                  activityName: activity.namaAktivitas,
                );

                _listKey.value.currentState?.removeItem(
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
                        child: _widgets.value[1],
                      ),
                    );
                  },
                  duration: duration,
                );
                _listKey.value.currentState?.removeItem(
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
                        child: _widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(
                    Duration(milliseconds: duration.inMilliseconds + 200));

                _widgets.value[1] = SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                );

                _listKey.value.currentState?.insertItem(
                  1,
                  duration: duration,
                );

                List<Map<String, String>> objects = [];

                for (int i = 0; i < _questions.value.length; i++) {
                  Map<String, String> object = {
                    'isi_jawaban': _answer.value[i],
                    'id_pertanyaan': _questions.value[i].idPertanyaan,
                  };

                  objects.add(object);
                }

                await context
                    .read(questionProvider.notifier)
                    .giveAnswerMultipleChoice(
                      context.read(hasuraClientProvider).state,
                      objects,
                      activity.idAktivitas,
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
                  questions: _questions.value,
                  answers: _answer.value,
                )));
              }
            },
        []);

    final _prevQuestion = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);

              if (_currentQuestion.value > 0) {
                _listKey.value.currentState?.removeItem(
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
                        child: _widgets.value[1],
                      ),
                    );
                  },
                  duration: duration,
                );
                _listKey.value.currentState?.removeItem(
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
                        child: _widgets.value[2],
                      ),
                    );
                  },
                  duration: duration,
                );

                await Future.delayed(
                    Duration(milliseconds: duration.inMilliseconds + 200));

                _currentQuestion.value -= 1;

                _widgets.value[0] = ActivityHeader(
                  progress: (_currentQuestion.value) / _questions.value.length,
                  activityName: activity.namaAktivitas,
                );

                _listKey.value.currentState?.insertItem(
                  1,
                  duration: duration,
                );

                _listKey.value.currentState?.insertItem(
                  2,
                  duration: duration,
                );
              }
            },
        []);

    final _initialAnimation = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 1000);
              for (int i = 0; i < _widgets.value.length; i++) {
                _listKey.value.currentState?.insertItem(
                  i,
                  duration: i == 0 ? duration : Duration(milliseconds: 500),
                );
                await Future.delayed(Duration(
                  milliseconds: i == 0 ? duration.inMilliseconds + 200 : 700,
                ));
              }
            },
        []);

    useEffect(() {
      context
          .read(questionProvider.notifier)
          .getQuestions(
              hasuraConnect: context.read(hasuraClientProvider).state,
              id: activity.idAktivitas,
              isMultiChoiceMany: true)
          .then((_) {
        _questions.value = context.read(questionProvider);

        _widgets.value = [
          ActivityHeader(
            progress: _currentQuestion.value / _questions.value.length,
            activityName: activity.namaAktivitas,
          ),
          QuestionsCard(
            questions: _questions.value.map((e) => e.isiPertanyaan).toList(),
            currentQuestions: _currentQuestion,
          ),
          MultipleQuestionCard(
            nextQuestion: _nextQuestion,
            prevQuestion: _prevQuestion,
            currentQuestion: _currentQuestion,
            saveAnswer: (value) {
              _answer.value.add(value);
              print(_answer.value);
            },
            isMultiChoiceMany: true,
          ),
        ];
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          _isLoading.value = false;
          Future.delayed(Duration(milliseconds: 200)).then((value) {
            _initialAnimation();
          });
        });
      });
      return;
    }, []);

    return _isLoading.value
        ? LoadingActivityPage()
        : Scaffold(
            backgroundColor: accentColor,
            body: SafeArea(
              child: AnimatedList(
                key: _listKey.value,
                initialItemCount: 0,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    key: Key('$index'),
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        end: Offset.zero,
                        begin: const Offset(0.0, -0.1),
                      )),
                      child: _widgets.value[index],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
