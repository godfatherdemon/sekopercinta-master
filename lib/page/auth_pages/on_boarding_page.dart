import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:page_view_sliding_indicator/page_view_sliding_indicator.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnBoardingPage extends HookWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);

    useEffect(() {
      pageController.addListener(() {
        currentPage.value = pageController.page!.round();
      });
      return;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'Sekoper Cinta',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: pageController,
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/images/img-onboarding1.png',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Ragam Isu dan Problematika\nWanita Jawa Barat',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Sebagai wanita di Jawa Barat, kita memiliki beberapa isu yang harus dihadapi seperti perkawinan anak, stunting, perceraian, kekerasan terhadap perempuan & anak, human traficking, serta angka kematian ibu, angka kematian bayi',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/images/img-onboarding2.png',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Women Empowerment,\nBerdaya, Bahagia, dan Juara',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Program dan Upaya dilakukan untuk memberikan dampak kepada Anda dan 23.76 Juta Perempuan di seluruh penjuru  Jawa Barat. ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/images/img-onboarding3.png',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Sekoper Cinta,\nCapai Impian dan Cita-Cita',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(
                                  'Satu-satunya program sekolah non-formal bagi perempuan Indonesia yang diselenggarakan pada level pemerintah provinsi. Kolaboratif, lintas sektor, memecahkan masalah dari hulu ke hilir.',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/images/img-onboarding4.png',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Fasilitator dan Mentor\nuntuk Anda',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Sekoper Cinta akan membantu Anda meningkatkan kualitas hidup Anda dengan menyediakan materi yang bermanfaat oleh para fasilitator ',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PageViewSlidingIndicator(
              controller: pageController,
              pageCount: 4,
              color: accentColor,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 106,
                    child: FillButton(
                      text: 'Kembali',
                      color: accentColor.withOpacity(0.16),
                      textColor: accentColor,
                      onTap: () {
                        if (pageController.page?.round() != 0) {
                          pageController.animateToPage(
                            currentPage.value - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      leading: Container(),
                    ),
                  ),
                  SizedBox(
                    width: 106,
                    child: FillButton(
                      text: 'Lanjut',
                      onTap: () {
                        if (pageController.page?.round() != 3) {
                          pageController.animateToPage(
                            currentPage.value + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          context
                              .read(authProvider.notifier)
                              .setFirstTimeUsingApp();
                          Navigator.pushAndRemoveUntil(
                              context,
                              createRoute(page: const BottomNavPage()),
                              (route) => false);
                        }
                      },
                      leading: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
