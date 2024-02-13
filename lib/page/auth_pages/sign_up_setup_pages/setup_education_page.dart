import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class SetupEducationPage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  SetupEducationPage({
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    final _education = useState<String?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              try {
                _isLoading.value = true;

                await context.read(userDataProvider.notifier).setUserData(
                  {'pendidikan_terakhir': _education.value},
                  context.read(hasuraClientProvider).state,
                );

                currentPage.value++;
                pageController.animateToPage(
                  currentPage.value,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
            },
        []);
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
              'Tingkat Pendidikan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Untuk menyusun pelatihan yang paling sesuai untuk Anda, beritahu kami tingkat pendidikan terakhir Anda.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'sd'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Sekolah Dasar (SD)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'sd',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'smp'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Sekolah Menengah Pertama (SMP)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'smp',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'sma'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Sekolah Menengah Atas (SMA)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'sma',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'smk'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Sekolah Menengah Kejuruan (SMK)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'smk',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'pt'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Kuliah',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'pt',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: _education.value == 'do'
                      ? accentColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Putus Hubungan Studi (Drop Out)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: 'do',
                groupValue: _education.value,
                onChanged: (String? value) {
                  _education.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 109,
            ),
            FillButton(
              text: 'Lanjutkan',
              onTap: _submit,
              isLoading: _isLoading.value,
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
