import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class FlipCardStatement extends HookWidget {
  final ValueNotifier<bool> isStart;
  final String question;

  const FlipCardStatement(this.isStart, this.question, {super.key});
  @override
  Widget build(BuildContext context) {
    // print(isStart.value);
    final Logger logger = Logger();
    logger.d(isStart.value);
    return AnimatedContainer(
      height: isStart.value ? 118 : MediaQuery.of(context).size.height - 100,
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<bool>(isStart.value),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isStart.value
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(18),
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
