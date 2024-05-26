import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class HomeProgress extends HookWidget {
  final ValueNotifier<int> _activeIndex;
  const HomeProgress(this._activeIndex, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 22,
          ),
          Text(
            'Pelajaran Anda',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Modul dan Kelas yang Anda ikuti saat ini',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              _activeIndex.value = 1;
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: gradientPrimary,
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg-card-1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modul Dasar',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Citra Diri Perempuan',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Text(
                              '1 dari 3 kelas diselesaikan',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 1 / 3,
                      minHeight: 8,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
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
