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
  late final String? selectedProgramYear;

  SetupHistoryPage({
    required this.pageController,
    required this.currentPage,
    this.selectedProgramYear,
  });
  @override
  Widget build(BuildContext context) {
    final _isDoneProgram = useState<bool>(false);
    final _programYear = useState<String?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              try {
                _isLoading.value = true;

                await context.read(userDataProvider.notifier).setUserData(
                  {'pernah_ikut_tahun': _programYear.value},
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
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                border: Border.all(
                  color:
                      _isDoneProgram.value ? accentColor : Colors.transparent,
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
                groupValue: _isDoneProgram.value,
                onChanged: (bool? value) {
                  _isDoneProgram.value = value!;
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
                  color:
                      !_isDoneProgram.value ? accentColor : Colors.transparent,
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
                groupValue: _isDoneProgram.value,
                onChanged: (bool? value) {
                  _isDoneProgram.value = value!;
                },
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    child: child,
                    sizeFactor: animation,
                    axis: Axis.vertical,
                  ),
                );
              },
              child: _isDoneProgram.value
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
                          value:
                              ValueNotifier<String>(_programYear.value ?? ''),
                          hint: 'Tahun Angkatan',
                          listString: [
                            for (var i = 2018; i < DateTime.now().year; i += 1)
                              i.toString()
                          ],
                          onSaved: (String? value) {
                            selectedProgramYear = value;
                          },
                          validator: (String? value) {},
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 109,
                    ),
            ),
            FillButton(
              text: 'Lanjutkan',
              isLoading: _isLoading.value,
              onTap: () {
                if (_isDoneProgram.value) {
                  if (_programYear.value == null) {
                    Fluttertoast.showToast(
                      msg: 'Mohon pilih tahun angkatan anda',
                    );
                    return;
                  }
                  _submit();
                } else {
                  currentPage.value++;
                  pageController.animateToPage(
                    currentPage.value,
                    duration: Duration(milliseconds: 300),
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
