import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_finish_page.dart';
import 'package:sekopercinta_master/page/camera_page/camera_page.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/file_upload_handler.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SetupProfilePage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  const SetupProfilePage({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final userData = useState<Map<String, dynamic>>({});
    final selectedProfile = useState<int?>(null);
    final selectedProfileFile = useState<File?>(null);

    final isLoading = useState(false);

    final submit = useMemoized(
        () => () async {
              try {
                if (!formKey.value.currentState!.validate()) {
                  return;
                }

                formKey.value.currentState?.save();

                if (selectedProfile.value == null) {
                  Fluttertoast.showToast(
                    msg: 'Mohon pilih foto profile',
                  );
                  return;
                }

                isLoading.value = true;

                if (selectedProfile.value != 0) {
                  userData.value['foto_profil'] =
                      '{{default_${selectedProfile.value}}}';
                } else {
                  if (selectedProfileFile.value != null) {
                    await context.read(userDataProvider.notifier).uploadProfile(
                          selectedProfileFile.value!,
                          context.read(hasuraClientProvider).state,
                        );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Mohon ambil gambar foto',
                    );
                    return;
                  }
                }

                await context.read(userDataProvider.notifier).setUserData(
                      userData.value,
                      context.read(hasuraClientProvider).state,
                    );

                Navigator.of(context).push(createRoute(
                    page: const SetupFinishPage(), isVertical: true));
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }
            },
        []);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: formKey.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
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
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Profil Anda',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Pengaturan akun Anda telah selesai! Sekarang saatnya melengkapi profil Anda!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: BorderedFormField(
                  hint: 'Nama',
                  onSaved: (value) {
                    userData.value['nama_pengguna'] = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                  textEditingController: TextEditingController(),
                  initialValue: '',
                  focusNode: FocusNode(),
                  onFieldSubmitted: (string) {},
                  maxLine: 999,
                  onChanged: (string) {},
                  onTap: () {},
                  suffixIcon: Container(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Nama ini akan ditampilkan sebagai Username anda, Anda dapat menggunakan nama panggilan maupun nama lengkap Anda.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tambahkan Foto Profil',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tambahkan foto profil Anda, atau pilih gambar yang Anda inginkan',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final action = await selectPhotoHandler(context);

                        if (action == null) {
                          return;
                        }

                        if (action == 'camera') {
                          if (await Permission.camera.request().isGranted) {
                            final selectedFilePath = await Navigator.of(context)
                                .push(createRoute(page: const CameraPage()));

                            if (selectedFilePath != null) {
                              selectedProfile.value = 0;
                              selectedProfileFile.value =
                                  File(selectedFilePath);
                            } else {
                              if (selectedProfileFile.value != null) {
                                selectedProfile.value = 0;
                              }
                            }
                          }
                        } else {
                          // FilePickerResult? result =
                          //     await FilePicker.platform.pickFiles(
                          //   type: FileType.custom,
                          //   allowedExtensions: ['jpg', 'png', 'jpeg'],
                          // );

                          // if (result != null) {
                          //   File file = File(result.files.single.path);

                          //   if (file.lengthSync() > 2097152) {
                          //     Fluttertoast.showToast(
                          //       msg: 'File harus kurang dari 2 Mb',
                          //     );
                          //     return;
                          //   }

                          //   _selectedProfile.value = 0;
                          //   _selectedProfileFile.value = file;
                          // } else {
                          //   if (_selectedProfileFile.value != null) {
                          //     _selectedProfile.value = 0;
                          //   }
                          // }

                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            String? filePath = result.files.single.path;

                            if (filePath != null) {
                              File file = File(filePath);

                              if (file.lengthSync() > 2097152) {
                                Fluttertoast.showToast(
                                  msg: 'File harus kurang dari 2 Mb',
                                );
                                return;
                              }

                              selectedProfile.value = 0;
                              selectedProfileFile.value = file;
                            } else {
                              // Handle the case where filePath is null
                              // (This might happen if the user canceled the file selection)
                            }
                          } else {
                            // Handle the case where result is null or files is empty
                            if (selectedProfileFile.value != null) {
                              selectedProfile.value = 0;
                            }
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        width: 88,
                        height: 88,
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedProfile.value == 0
                                ? accentColor
                                : const Color(0xFFE7E4E2),
                          ),
                          image: selectedProfileFile.value != null
                              ? DecorationImage(
                                  image: FileImage(selectedProfileFile.value!),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic-camera.png',
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        selectedProfile.value = 1;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: selectedProfile.value == 1
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedProfile.value == 1
                                ? accentColor
                                : const Color(0xFFE7E4E2),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/img-women-a.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        selectedProfile.value = 2;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: selectedProfile.value == 2
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedProfile.value == 2
                                ? accentColor
                                : const Color(0xFFE7E4E2),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/img-women-b.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        selectedProfile.value = 3;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: selectedProfile.value == 3
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedProfile.value == 3
                                ? accentColor
                                : const Color(0xFFE7E4E2),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/img-women-c.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FillButton(
                  text: 'Lanjutkan',
                  isLoading: isLoading.value,
                  onTap: submit,
                  leading: Container(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FillButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
