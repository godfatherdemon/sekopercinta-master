import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/utils/constants.dart';

class QuestionsCard extends HookWidget {
  final List<String> questions;
  final ValueNotifier<int> currentQuestions;
  QuestionsCard({required this.questions, required this.currentQuestions});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(child: child, sizeFactor: animation),
          );
        },
        child: Column(
          key: ValueKey<int>(currentQuestions.value),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentQuestions.value + 1}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: secondaryDarkColor,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              questions[currentQuestions.value],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
