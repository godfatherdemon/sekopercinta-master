import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/camera_page/camera_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/file_upload_handler.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class SetupEducationCertificatePage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  SetupEducationCertificatePage({
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    final _selectedFile = useState<File?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              try {
                if (_selectedFile.value == null) {
                  Fluttertoast.showToast(
                    msg: 'Mohon pilih file Anda',
                  );
                  return;
                }

                _isLoading.value = true;

                if (_selectedFile.value!.lengthSync() > 2097152) {
                  Fluttertoast.showToast(
                    msg: 'File harus kurang dari 2 Mb',
                  );
                  return;
                }

                final url = await getSignedLink(
                    file: _selectedFile.value!,
                    hasuraConnect: context.read(hasuraClientProvider).state,
                    docType: 'diploma');

                await sendFile(_selectedFile.value!, url);

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
    return Padding(
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
          InkWell(
            borderRadius: BorderRadius.circular(8),
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
                    File file = File(selectedFilePath);

                    if (file.lengthSync() > 2097152) {
                      Fluttertoast.showToast(
                        msg: 'File harus kurang dari 2 Mb',
                      );
                      return;
                    }

                    _selectedFile.value = file;
                  }
                }
              } else {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                );

                if (result != null) {
                  File file = File(result.files.single.path!);

                  if (file.lengthSync() > 2097152) {
                    Fluttertoast.showToast(
                      msg: 'File harus kurang dari 2 Mb',
                    );
                    return;
                  }

                  _selectedFile.value = file;
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE7E4E2),
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
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        _selectedFile.value != null
                            ? 'assets/images/ic-upload-done.png'
                            : 'assets/images/ic-upload.png',
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
                          _selectedFile.value != null
                              ? basename(_selectedFile.value!.path)
                              : 'Upload Ijazah / Sertifikat',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _selectedFile.value != null
                              ? '${(_selectedFile.value!.lengthSync() / 1000000).toStringAsFixed(1)} Mb'
                              : 'Jenis file PDF, JPEG, PNG, Ukuran Maks 2Mb',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        if (_selectedFile.value != null)
                          Text(
                            'Upload Ulang',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: accentColor,
                                    ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(),
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
    );
  }
}
