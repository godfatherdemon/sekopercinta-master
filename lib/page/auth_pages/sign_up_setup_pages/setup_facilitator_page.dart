import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class SetupFacilitatorPage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  const SetupFacilitatorPage({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                  'assets/images/img-womans.png',
                  width: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Fasilitator Anda',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Berdasarkan lokasi yang Anda masukkan, kami mencocokkan Anda dengan fasilitator di daerah Anda',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE7E4E2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    color: accentColor,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ikah Atikah',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Fasilitator daerah Kota Bandung Bekerja sebagai Guru',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
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
                    'Hubungi Fasilitator',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: accentColor,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Anda dapat menghubungi fasilitator tersebut untuk memperoleh bantuan pelatihan dan lainnya',
                    style: Theme.of(context).textTheme.bodyLarge,
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
                  duration: const Duration(milliseconds: 300),
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
                  duration: const Duration(milliseconds: 300),
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
