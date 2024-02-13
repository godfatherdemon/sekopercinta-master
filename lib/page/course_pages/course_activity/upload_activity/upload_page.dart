import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  UploadPage({required this.activity});
  @override
  Widget build(BuildContext context) {
    final _listKey = useState(GlobalKey<AnimatedListState>());
    final _isLoading = useState(true);
    final _widgets = useState<List<Widget>>([]);
    final _currentQuestion = useState(0);
    final _questions = useState<List<String>>([]);
    final _answer = useState<List<String>>([]);
    final _selectedFile = useState<File?>(null);

    final _nextQuestion = useMemoized(
        () => () async {
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
                    questions: _questions.value,
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
                    'id_pertanyaan': _questions.value[i],
                  };

                  objects.add(object);
                }

                await context
                    .read(activityProvider.notifier)
                    .sendActivityCommunityImage(
                      file: _selectedFile.value!,
                      comment: _answer.value[1],
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
                  answers: _answer.value,
                  questions: [
                    Pertanyaan(
                      isiPertanyaan: _questions.value[0],
                      idPertanyaan: '',
                      kunciJawabanPilgans: [],
                      pilihanJawaban: [],
                    ),
                    Pertanyaan(
                      isiPertanyaan: _questions.value[1],
                      idPertanyaan: '',
                      kunciJawabanPilgans: [],
                      pilihanJawaban: [],
                    ),
                  ],
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

    final _showQuestion = useMemoized(
        () => () async {
              final duration = Duration(milliseconds: 500);
              _listKey.value.currentState?.removeItem(
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
                      child: _widgets.value[0],
                    ),
                  );
                },
                duration: duration,
              );
              _listKey.value.currentState?.removeItem(
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
                      child: _widgets.value[1],
                    ),
                  );
                },
                duration: duration,
              );

              await Future.delayed(
                  Duration(milliseconds: duration.inMilliseconds + 200));

              _widgets.value = [
                ActivityHeader(
                  progress: _currentQuestion.value / _questions.value.length,
                  activityName: activity.namaAktivitas,
                ),
                QuestionsCard(
                  questions: _questions.value,
                  currentQuestions: _currentQuestion,
                ),
                UploadCard(
                  nextQuestion: _nextQuestion,
                  prevQuestion: _prevQuestion,
                  saveAnswer: (value) {
                    _answer.value.add(value);
                    print(_answer.value);
                  },
                  currentQuestion: _currentQuestion,
                  selectedFile: ValueNotifier<File>(
                    _selectedFile.value ?? File('default_path'),
                  ),
                ),
              ];

              Future.delayed(Duration(milliseconds: 200)).then((value) {
                _initialAnimation();
              });
            },
        []);

    useEffect(() {
      context
          .read(questionProvider.notifier)
          .getUploadInstruction(
              context.read(hasuraClientProvider).state, activity.idAktivitas)
          .then((value) {
        _questions.value = [
          value[0]['instruksi_unggah'],
          value[0]['instruksi_komentar']
        ];
        _widgets.value = [
          UploadInstruction(),
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
