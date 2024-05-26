import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/drop_down_text_field.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class SetupHistoryPage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final String? selectedProgramYear;

  const SetupHistoryPage({
    super.key,
    required this.pageController,
    required this.currentPage,
    this.selectedProgramYear,
  });
  @override
  Widget build(BuildContext context) {
    final isDoneProgram = useState<bool>(false);
    final programYear = useState<String?>(null);

    final isLoading = useState(false);

    final submit = useMemoized(
        () => () async {
              try {
                isLoading.value = true;

                await context.read(userDataProvider.notifier).setUserData(
                  {'pernah_ikut_tahun': programYear.value},
                  context.read(hasuraClientProvider).state,
                );

                currentPage.value++;
                pageController.animateToPage(
                  currentPage.value,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }
            },
        []);
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
                  'assets/images/img-paper.png',
                  width: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Pernah ikut Sekoper Cinta?',
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
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color: isDoneProgram.value ? accentColor : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<bool>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Ya, saya telah mengikuti program Sekoper Cinta sebelumnya',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: true,
                groupValue: isDoneProgram.value,
                onChanged: (bool? value) {
                  isDoneProgram.value = value!;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color:
                      !isDoneProgram.value ? accentColor : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<bool>(
                activeColor: accentColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  'Tidak, saya belum pernah mengikuti program Sekoper Cinta',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: accentColor),
                ),
                value: false,
                groupValue: isDoneProgram.value,
                onChanged: (bool? value) {
                  isDoneProgram.value = value!;
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    child: child,
                  ),
                );
              },
              child: isDoneProgram.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Angkatan Anda',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Pada angkatan keberapakah Anda mengikuti program Sekoper Cinta?',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropDownTextField(
                          value: ValueNotifier<String>(programYear.value ?? ''),
                          hint: 'Tahun Angkatan',
                          listString: [
                            for (var i = 2018; i < DateTime.now().year; i += 1)
                              i.toString()
                          ],
                          onSaved: (String? value) {
                            // selectedProgramYear = value;
                            selectedProgramYear;
                          },
                          validator: (String? value) {},
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 109,
                    ),
            ),
            FillButton(
              text: 'Lanjutkan',
              isLoading: isLoading.value,
              onTap: () {
                if (isDoneProgram.value) {
                  if (programYear.value == null) {
                    Fluttertoast.showToast(
                      msg: 'Mohon pilih tahun angkatan anda',
                    );
                    return;
                  }
                  submit();
                } else {
                  currentPage.value++;
                  pageController.animateToPage(
                    currentPage.value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
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
