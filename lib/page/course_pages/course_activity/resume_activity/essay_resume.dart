import 'package:flutter/material.dart';
import 'package:sekopercinta/providers/questions.dart';
import 'package:sekopercinta/utils/constants.dart';

class EssayResumeComponents extends StatelessWidget {
  final List<Pertanyaan> question;
  final List<String> answer;

  EssayResumeComponents({
    required this.answer,
    required this.question,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: question.length,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 24,
      ),
      itemBuilder: (context, index) => Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF4F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accentColor,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  question[index].isiPertanyaan,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
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
                  'Jawaban Anda',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accentColor,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  answer[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
