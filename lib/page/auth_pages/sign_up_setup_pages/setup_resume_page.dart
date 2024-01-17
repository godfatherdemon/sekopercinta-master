import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SetupResumePage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  SetupResumePage({
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/img-paper.png',
                  width: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Resume',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Bersiaplah menggapai cita-cita Anda. Berdasarkan profil yang Anda bagikan Anda akan mempelajari: ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE7E4E2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (context.read(userDataProvider).pendidikanTerakhir !=
                          'smk' &&
                      context.read(userDataProvider).pendidikanTerakhir !=
                          'pt' &&
                      context.read(userDataProvider).pendidikanTerakhir != 'do')
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: primaryDarkColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/img-book.png',
                                  width: 32,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modul Dasar',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Dapatkan berbagai pengetahuan dan keterampilan dasar untuk Perempuan',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: primaryDarkColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/img-lamp.png',
                                  width: 32,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modul Tematik',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Pelajari topik yang berfokus pada masalah tertentu bagi Perempuan',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: primaryDarkColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/img-hand.png',
                            width: 32,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modul Keterampilan',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Modul untuk meningkatkan keahlian hard-skill Anda.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 109,
            ),
            FillButton(
              text: 'Lanjutkan',
              onTap: () {
                currentPage.value++;
                pageController.animateToPage(
                  currentPage.value,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              leading: Container(),
            ),
            const SizedBox(
              height: 16,
            ),
            FillButton(
              color: Colors.transparent,
              textColor: accentColor,
              text: 'Kembali',
              onTap: () {
                currentPage.value--;
                pageController.animateToPage(
                  currentPage.value,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              leading: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
