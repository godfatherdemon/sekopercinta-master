import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta/components/course_components/activity_components/essay_question_card.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/page/camera_page/camera_page.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/file_upload_handler.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class UploadCard extends HookWidget {
  final Function nextQuestion;
  final Function prevQuestion;
  final Function(String) saveAnswer;
  final ValueNotifier<int> currentQuestion;
  final ValueNotifier<File> selectedFile;

  UploadCard({
    required this.nextQuestion,
    required this.prevQuestion,
    required this.saveAnswer,
    required this.currentQuestion,
    required this.selectedFile,
  });
  @override
  Widget build(BuildContext context) {
    final _isChangingPhoto = useState(false);
    return currentQuestion.value == 1
        ? EssayQuestionCard(
            nextQuestion: nextQuestion,
            prevQuestion: prevQuestion,
            saveAnswer: saveAnswer,
            currentQuestion: currentQuestion)
        : Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unggah foto',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(16),
                          dashPattern: [4, 4, 4, 4],
                          color: Color(0xFFE75C96),
                          child: InkWell(
                            onTap: () async {
                              final action = await selectPhotoHandler(context);

                              if (action == null) {
                                return;
                              }

                              if (action == 'camera') {
                                if (await Permission.camera
                                    .request()
                                    .isGranted) {
                                  final selectedFilePath =
                                      await Navigator.of(context).push(
                                          createRoute(page: CameraPage()));

                                  if (selectedFilePath != null) {
                                    selectedFile.value = File(selectedFilePath);
                                    _isChangingPhoto.value =
                                        !_isChangingPhoto.value;
                                  }
                                }
                              } else {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );

                                // if (result != null) {
                                //   File file = File(result.files.single.path);

                                //   if (file.lengthSync() > 2097152) {
                                //     Fluttertoast.showToast(
                                //       msg: 'File harus kurang dari 2 Mb',
                                //     );
                                //     return;
                                //   }

                                //   selectedFile.value = file;
                                //   _isChangingPhoto.value =
                                //       !_isChangingPhoto.value;
                                // }
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

                                    selectedFile.value = file;
                                  } else {
                                    // Handle the case when the file path is null
                                  }
                                }
                              }
                              print(selectedFile.value.path);
                            },
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(14),
                                  image: DecorationImage(
                                      image: FileImage(selectedFile.value),
                                      fit: BoxFit.cover)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/img-camera.png',
                                    width: 80,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Unggah foto hasil praktik',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          // ignore: unnecessary_null_comparison
                                          color: selectedFile.value == null
                                              ? primaryBlack
                                              : Colors.white,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Format diterima JPEG. PNG',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          // ignore: unnecessary_null_comparison
                                          color: selectedFile.value == null
                                              ? primaryBlack
                                              : Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF3EEFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unggah foto tabel',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: primaryVeryDarkColor,
                                    ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Di aktivitas ini foto Anda akan dibagikan di halaman komunitas Sekoper Cinta!',
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (currentQuestion.value != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InkWell(
                        onTap: () {
                          prevQuestion();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Kembali ke pertanyaan sebelumnya',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FillButton(
                      text: 'Lanjutkan',
                      color: Colors.white,
                      textColor: accentColor,
                      onTap: () {
                        // if (selectedFile.value == null) {
                        //   Fluttertoast.showToast(
                        //     msg: 'Mohon masukkan gambar',
                        //   );
                        //   return;
                        // }
                        saveAnswer(selectedFile.value.path);
                        nextQuestion();
                      },
                      leading: Container(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 36,
              ),
            ],
          );
  }
}
