import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnswerManyInstruction extends StatelessWidget {
  const AnswerManyInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/anm-add.json',
            width: 120,
            height: 120,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Jawablah sebanyak mungkin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Tulislah jawaban yang sesuai dengan pertanyaan yang diberikan kepada Anda sebanyak-banyaknya sesuai dengan pemahaman Anda',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
