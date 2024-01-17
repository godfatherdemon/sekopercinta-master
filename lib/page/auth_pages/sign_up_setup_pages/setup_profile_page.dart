import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/page/auth_pages/sign_up_setup_pages/setup_finish_page.dart';
import 'package:sekopercinta/page/camera_page/camera_page.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/file_upload_handler.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SetupProfilePage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  SetupProfilePage({
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _userData = useState<Map<String, dynamic>>({});
    final _selectedProfile = useState<int?>(null);
    final _selectedProfileFile = useState<File?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              try {
                if (!_formKey.value.currentState!.validate()) {
                  return;
                }

                _formKey.value.currentState?.save();

                if (_selectedProfile.value == null) {
                  Fluttertoast.showToast(
                    msg: 'Mohon pilih foto profile',
                  );
                  return;
                }

                _isLoading.value = true;

                if (_selectedProfile.value != 0) {
                  _userData.value['foto_profil'] =
                      '{{default_${_selectedProfile.value}}}';
                } else {
                  if (_selectedProfileFile.value != null) {
                    await context.read(userDataProvider.notifier).uploadProfile(
                          _selectedProfileFile.value!,
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
                      _userData.value,
                      context.read(hasuraClientProvider).state,
                    );

                Navigator.of(context).push(
                    createRoute(page: SetupFinishPage(), isVertical: true));
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
            },
        []);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey.value,
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
                    _userData.value['nama_pengguna'] = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
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
                                .push(createRoute(page: CameraPage()));

                            if (selectedFilePath != null) {
                              _selectedProfile.value = 0;
                              _selectedProfileFile.value =
                                  File(selectedFilePath);
                            } else {
                              if (_selectedProfileFile.value != null) {
                                _selectedProfile.value = 0;
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

                              _selectedProfile.value = 0;
                              _selectedProfileFile.value = file;
                            } else {
                              // Handle the case where filePath is null
                              // (This might happen if the user canceled the file selection)
                            }
                          } else {
                            // Handle the case where result is null or files is empty
                            if (_selectedProfileFile.value != null) {
                              _selectedProfile.value = 0;
                            }
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        width: 88,
                        height: 88,
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedProfile.value == 0
                                ? accentColor
                                : Color(0xFFE7E4E2),
                          ),
                          image: _selectedProfileFile.value != null
                              ? DecorationImage(
                                  image: FileImage(_selectedProfileFile.value!),
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
                        _selectedProfile.value = 1;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: _selectedProfile.value == 1
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedProfile.value == 1
                                ? accentColor
                                : Color(0xFFE7E4E2),
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
                        _selectedProfile.value = 2;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: _selectedProfile.value == 2
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedProfile.value == 2
                                ? accentColor
                                : Color(0xFFE7E4E2),
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
                        _selectedProfile.value = 3;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: _selectedProfile.value == 3
                              ? accentColor.withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedProfile.value == 3
                                ? accentColor
                                : Color(0xFFE7E4E2),
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
                  isLoading: _isLoading.value,
                  onTap: _submit,
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
                      duration: Duration(milliseconds: 300),
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
