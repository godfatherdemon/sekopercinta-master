import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  AnswerManyPage({required this.activity});
  @override
  Widget build(BuildContext context) {
    final _listKey = useState(GlobalKey<AnimatedListState>());
    final _isLoading = useState(true);
    final _widgets = useState<List<Widget>>([]);
    final _isStart = useState(false);
    final _currentQuestion = useState(0);
    final _questions = useState<List<Pertanyaan>>([]);
    final _answer = useState<List<String>>([]);

    final _finishQuestion = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);

              if (!(_currentQuestion.value < _questions.value.length - 1)) {
                _widgets.value[0] = FlipCardHeader(
                  _isStart,
                  1,
                  activity.namaAktivitas,
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

                for (int i = 0; i < _answer.value.length; i++) {
                  Map<String, String> object = {
                    'isi_jawaban': _answer.value[i],
                    'id_pertanyaan': _questions.value[0].idPertanyaan,
                  };

                  objects.add(object);
                }

                var answer = _answer.value.toString().replaceFirst('[', '{');

                print(answer.length);

                answer = answer.replaceRange(answer.length - 1, null, '}');

                await context.read(questionProvider.notifier).giveAnswerMany(
                      context.read(hasuraClientProvider).state,
                      answer,
                      _questions.value[0].idPertanyaan,
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
                  answers: _answer.value,
                  questions: _questions.value,
                )));
              }
            },
        []);

    final _startActivity = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);

              // await Future.delayed(Duration(milliseconds: 700));

              _isStart.value = false;
              _widgets.value[0] = FlipCardHeader(
                  _isStart,
                  _currentQuestion.value / _questions.value.length,
                  activity.namaAktivitas);
              _widgets.value[2] = AnswerManyQuestions(
                isStart: _isStart,
                answers: _answer,
                finish: _finishQuestion,
              );

              _widgets.value[1] = AnswerManyStatement(
                  _isStart, _questions.value[0].isiPertanyaan);
              _isStart.value = true;

              _listKey.value.currentState?.removeItem(
                2,
                (context, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: _widgets.value[2],
                  );
                },
                duration: Duration.zero,
              );

              await Future.delayed(Duration(milliseconds: 500));

              _listKey.value.currentState?.insertItem(
                2,
                duration: duration,
              );
            },
        []);

    final _showQuestion = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);
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

              _widgets.value[1] = AnswerManyStatement(
                  _isStart, _questions.value[0].isiPertanyaan);
              _widgets.value[2] = Padding(
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
                    _startActivity();
                  },
                  leading: Container(),
                ),
              );

              _listKey.value.currentState?.insertItem(
                1,
                duration: duration,
              );

              _listKey.value.currentState?.insertItem(
                2,
                duration: duration,
              );
            },
        []);

    final _initialAnimation = useMemoized(
        () => () async {
              for (int i = 0; i < _widgets.value.length; i++) {
                _listKey.value.currentState?.insertItem(
                  i,
                  duration: i == 0 || i == 2
                      ? Duration.zero
                      : Duration(milliseconds: 500),
                );

                if (i != 0 && i != 2) {
                  await Future.delayed(Duration(
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
        _questions.value = context.read(questionProvider);

        _widgets.value = [
          FlipCardHeader(
              _isStart,
              _currentQuestion.value / _questions.value.length,
              _questions.value[0].isiPertanyaan),
          AnswerManyInstruction(),
          AnswerManyQuestions(
            isStart: _isStart,
            answers: _answer,
            finish: _finishQuestion,
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
                _showQuestion();
              },
              leading: Container(),
            ),
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
