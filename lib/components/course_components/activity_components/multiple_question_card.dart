import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/providers/answers.dart';
import 'package:sekopercinta/providers/questions.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MultipleQuestionCard extends HookWidget {
  final Function nextQuestion;
  final Function prevQuestion;
  final Function(String) saveAnswer;
  final ValueNotifier<int> currentQuestion;
  final bool isMultiChoiceMany;

  MultipleQuestionCard({
    required this.nextQuestion,
    required this.prevQuestion,
    required this.saveAnswer,
    required this.currentQuestion,
    this.isMultiChoiceMany = false,
  });
  @override
  Widget build(BuildContext context) {
    final _answers = useState<List<Answer>>(!isMultiChoiceMany
        ? context.read(answersProvider)
        : context.read(questionProvider)[currentQuestion.value].pilihanJawaban);
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: _answers.value.length + 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 12,
                ),
                itemBuilder: (context, index) => index < _answers.value.length
                    ? FillButton(
                        text: _answers.value[index].tampilanJawaban,
                        color: accentColor.withOpacity(0.12),
                        textColor: accentColor,
                        onTap: () {
                          saveAnswer(_answers.value[index].isiJawaban);
                          nextQuestion(true);
                        },
                        leading: Container(),
                      )
                    : FillButton(
                        text: 'Tidak Tahu',
                        color: accentColor.withOpacity(0.12),
                        textColor: accentColor,
                        onTap: () {
                          saveAnswer('-');
                          nextQuestion(true);
                        },
                        leading: Container(),
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (currentQuestion.value != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () {
                    prevQuestion();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Kembali ke pertanyaan sebelumnya',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }
}
