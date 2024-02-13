import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/flip_card_header.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/flip_card_questions.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/flip_card_statement.dart';
import 'package:sekopercinta_master/components/course_components/activity_components/flip_instruction.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/loading_activity_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

import '../finish_activity_page.dart';

class FlipCardPage extends HookWidget {
  final Aktivitas activity;
  FlipCardPage({required this.activity});
  @override
  Widget build(BuildContext context) {
    final _listKey = useState(GlobalKey<AnimatedListState>());
    final _isLoading = useState(true);
    final _widgets = useState<List<Widget>>([]);
    final _isStart = useState(false);
    final _currentQuestion = useState(0);
    final _questions = useState<String?>(null);
    final _answer = useState<List<bool>>([]);

    final _sendAnswer = useMemoized(
        () => () async {
              List<Map<String, dynamic>> objects = [];

              final choices = context.read(questionProvider);

              for (int i = 0; i < _answer.value.length; i++) {
                Map<String, dynamic> object = {
                  'isi_jawaban': _answer.value[i],
                  'id_pertanyaan': choices[i].idPertanyaan,
                };

                objects.add(object);
              }

              await context.read(questionProvider.notifier).giveAnswerTrueFalse(
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
                questions: [
                  Pertanyaan(
                      isiPertanyaan: _questions.value!,
                      idPertanyaan: _questions.value!,
                      kunciJawabanPilgans: [],
                      pilihanJawaban: [])
                ],
                answers: _answer.value.map((e) => e.toString()).toList(),
              )));
            },
        []);

    final _startActivity = useMemoized(
        () => () async {
              // final duration = Duration(milliseconds: 500);

              //
              // await Future.delayed(Duration(milliseconds: 700));
              //

              _isStart.value = false;
              _widgets.value[0] = FlipCardHeader(
                _isStart,
                _currentQuestion.value / _questions.value!.length,
                activity.namaAktivitas,
              );
              _widgets.value[1] = FlipCardQuestions(
                _isStart,
                (value) {
                  _answer.value.add(value);

                  if (_answer.value.length ==
                      context.read(questionProvider).length) {
                    _sendAnswer();
                  }
                  print(_answer.value);
                },
              );
              _widgets.value[2] =
                  FlipCardStatement(_isStart, _questions.value!);
              _isStart.value = true;

              _listKey.value.currentState?.removeItem(
                3,
                (context, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: _widgets.value[1],
                  );
                },
                duration: Duration.zero,
              );
              //
              // // await Future.delayed(
              // //     Duration(milliseconds: duration.inMilliseconds + 200));
              //

              // // await Future.delayed(
              // //     Duration(milliseconds: duration.inMilliseconds + 200));

              // _widgets.value.insert(
              //     0,
              //     ActivityHeader(
              //       progress: _currentQuestion.value / _questions.value.length,
              //     ));
              // _widgets.value.insert(
              //     1,
              //     Container(
              //       height: 319,
              //       width: double.infinity,
              //       color: Colors.white,
              //     ));

              //
              // // _widgets.value[2] = FlipCardStatement(_isStart);
              //
              // _listKey.value.currentState.insertItem(
              //   0,
              //   duration: duration,
              // );
              //
              // _listKey.value.currentState.insertItem(
              //   1,
              //   duration: duration,
              // );
            },
        []);

    final _showQuestion = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);
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
                      child: _widgets.value[3],
                    ),
                  );
                },
                duration: duration,
              );

              await Future.delayed(
                  Duration(milliseconds: duration.inMilliseconds + 200));

              _widgets.value[2] =
                  FlipCardStatement(_isStart, _questions.value!);
              _widgets.value[3] = Padding(
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
                2,
                duration: duration,
              );

              _listKey.value.currentState?.insertItem(
                3,
                duration: duration,
              );
            },
        []);

    final _initialAnimation = useMemoized(
        () => () async {
              for (int i = 0; i < _widgets.value.length; i++) {
                _listKey.value.currentState?.insertItem(
                  i,
                  duration: i == 0 || i == 1
                      ? Duration.zero
                      : Duration(milliseconds: 500),
                );

                if (i != 0 && i != 1) {
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
          .getTrueFalseQuestion(
              context.read(hasuraClientProvider).state, activity.idAktivitas)
          .then((value) {
        context
            .read(questionProvider.notifier)
            .getQuestions(
                hasuraConnect: context.read(hasuraClientProvider).state,
                id: activity.idAktivitas)
            .then((_) {
          _questions.value = value['isi_pernyataan'];

          _widgets.value = [
            FlipCardHeader(
                _isStart,
                _currentQuestion.value / _questions.value!.length,
                activity.namaAktivitas),
            FlipCardQuestions(
              _isStart,
              (value) {
                _answer.value.add(value);

                if (_answer.value.length ==
                    context.read(questionProvider).length) {
                  _sendAnswer();
                }

                print(_answer.value);
              },
            ),
            FlipInstruction(),
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
