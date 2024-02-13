import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FlipInstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/anm-swipe.json',
            width: 120,
            height: 120,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Geser ke kiri atau kanan',
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
              'Geserlah kartu ke kanan untuk pernyataan yang benar, dan geser ke kiri untuk pernyataan yang salah berdasarkan pemahaman Anda terhdadap pernyataan yang akan diberikan',
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
