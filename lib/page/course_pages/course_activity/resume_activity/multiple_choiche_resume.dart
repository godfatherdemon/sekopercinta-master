import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class MultipleChoiceResume extends HookWidget {
  final List<Pertanyaan> question;
  final List<String> answer;

  const MultipleChoiceResume({
    super.key,
    required this.answer,
    required this.question,
  });
  @override
  Widget build(BuildContext context) {
    final answerNA = useState<int>(0);
    final rightAnswer = useState<int>(0);
    final wrongAnswer = useState<int>(0);
    final totalScore = useState(0.0);
    useEffect(() {
      if (question[0].kunciJawabanPilgans.isNotEmpty) {
        for (int i = 0; i < answer.length; i++) {
          if (answer[i] == '-') {
            answerNA.value++;
          }
          if (answer[i] == question[i].kunciJawabanPilgans[0].isiJawaban) {
            rightAnswer.value++;
          } else {
            wrongAnswer.value++;
          }
        }

        totalScore.value = (rightAnswer.value / answer.length) * 100;
      }

      return;
    }, []);
    return Column(
      children: [
        if (question[0].kunciJawabanPilgans.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 36,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 128,
                    width: 196,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -35,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ic-star-score.png',
                          width: 108,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Skor Anda',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          totalScore.value.toStringAsFixed(0),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 102,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jawaban Benar',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: accentColor,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${rightAnswer.value}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: primaryVeryDarkColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 102,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jawaban Salah',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: accentColor,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${wrongAnswer.value}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: primaryVeryDarkColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 102,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jawaban Tidak Tahu',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: accentColor,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${answerNA.value}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: primaryVeryDarkColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (question[0].kunciJawabanPilgans.isEmpty)
          Column(
            children: [
              const SizedBox(
                height: 36,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 128,
                    width: 196,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -35,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ic-star-score.png',
                          width: 108,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Skor Anda',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '100',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
      ],
    );
  }
}
