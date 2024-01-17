import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/utils/constants.dart';

class AnswerManyStatement extends HookWidget {
  final ValueNotifier<bool> isStart;
  final String question;

  AnswerManyStatement(this.isStart, this.question);
  @override
  Widget build(BuildContext context) {
    print(isStart.value);
    return AnimatedContainer(
      height: isStart.value ? 105 : MediaQuery.of(context).size.height - 100,
      duration: Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<bool>(isStart.value),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color:
                    isStart.value ? Colors.white.withOpacity(0) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(isStart.value ? 0 : 18),
              child: Column(
                children: [
                  Text(
                    'Statement',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              isStart.value ? Colors.white : secondaryDarkColor,
                        ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    question,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isStart.value ? Colors.white : primaryBlack),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
