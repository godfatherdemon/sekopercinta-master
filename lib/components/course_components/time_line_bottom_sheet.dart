import 'package:flutter/material.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class TimeLineBottomSheet extends StatelessWidget {
  const TimeLineBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () => Navigator.of(context).pop(),
          child: const SizedBox(
            height: 100,
            width: double.infinity,
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 4,
                  width: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 133,
                            height: 133,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/img-calendar.png',
                                height: 80,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Tentang Timeline',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: primaryVeryDarkColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Program belajar Sekoper Cinta mengikuti timeline yang disesuaikan dengan tiap angkatan',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: const Color(0xFFA2A1A1),
                                ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Apabila saya melewati waktu Berakhir pada...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: primaryDarkColor,
                                      ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Apabila anda belum menyelesaikan semua modul pada waktu berakhirnya masa belajar Angkatan maka anda tetap dapat melanjutkan pelajaran Anda, namun untuk melakukan sertifikasi dan wisuda akan dimasukkan ke angkatan dan periode selanjutnya',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: primaryDarkColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
