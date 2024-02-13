import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlipCardResumeComponents extends HookWidget {
  final List<Pertanyaan> question;
  final List<String> answer;

  FlipCardResumeComponents({
    required this.answer,
    required this.question,
  });
  @override
  Widget build(BuildContext context) {
    final _myTrueAnswer = useState([]);
    useEffect(() {
      for (int i = 0; i < answer.length; i++) {
        if (answer[i] == 'true') {
          _myTrueAnswer.value
              .add(context.read(questionProvider)[i].isiPertanyaan);
        }
      }
      return;
    }, []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statement',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          question[0].isiPertanyaan,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF9B6EE5).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jawaban Anda',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryVeryDarkColor,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(
                height: 13,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: _myTrueAnswer.value.length,
                padding: const EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _myTrueAnswer.value[index],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: primaryVeryDarkColor,
                        ),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Color(0xFF9B6EE5).withOpacity(0.4),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
