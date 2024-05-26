import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/page/camera_page/camera_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/file_upload_handler.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class AddPostPage extends HookWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final postDescription = useState<String?>(null);
    final isLoading = useState(false);
    final selectedFile = useState<File?>(null);

    final addPost = useMemoized(
        () => () async {
              final navigator = Navigator.of(context);
              if (selectedFile.value == null) {
                Fluttertoast.showToast(
                  msg: 'Mohon masukkan foto',
                );
              }

              if (!formKey.value.currentState!.validate()) {
                return;
              }
              formKey.value.currentState?.save();
              // print(postDescription.value);
              final Logger logger = Logger();
              logger.d(postDescription.value);

              isLoading.value = true;

              try {
                await context
                    .read(activityProvider.notifier)
                    .sendCommunityImage(
                      file: selectedFile.value!,
                      comment: postDescription.value!,
                      hasuraConnect: context.read(hasuraClientProvider).state,
                    );

                isLoading.value = false;
                // Navigator.of(context).pop(true);
                navigator.pop('add photo');
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }
            },
        []);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Form(
          key: formKey.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.only(right: 20, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      isLoading.value
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: addPost,
                              borderRadius: BorderRadius.circular(8),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'Tambah',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0FC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Komunitas Post',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: primaryDarkColor,
                                  ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Post Anda akan tampil di komunitas post',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: primaryVeryDarkColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Unggah foto',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(16),
                        dashPattern: const [4, 4, 4, 4],
                        color: const Color(0xFFE75C96),
                        child: InkWell(
                          onTap: () async {
                            final action = await selectPhotoHandler(context);

                            if (action == null) {
                              return;
                            }

                            if (action == 'camera') {
                              if (await Permission.camera.request().isGranted) {
                                final selectedFilePath =
                                    await Navigator.of(context).push(
                                        createRoute(page: const CameraPage()));

                                if (selectedFilePath != null) {
                                  selectedFile.value = File(selectedFilePath);
                                }
                              }
                            } else {
                              // FilePickerResult result =
                              //     await FilePicker.platform.pickFiles(
                              //   type: FileType.custom,
                              //   allowedExtensions: ['jpg', 'png', 'jpeg'],
                              // );
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

                              //   _selectedFile.value = file;
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
                          },
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(14),
                              image: selectedFile.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        selectedFile.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
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
                        height: 24,
                      ),
                      Text(
                        'Deskripsi Post',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      BorderedFormField(
                        hint: 'Tulis deskripsi post....',
                        keyboardType: TextInputType.multiline,
                        maxLine: 7,
                        onSaved: (value) {
                          postDescription.value = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Deskripsi post tidak boleh kosong';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          addPost();
                        },
                        textEditingController: TextEditingController(),
                        initialValue: '',
                        focusNode: FocusNode(),
                        onChanged: (string) {},
                        onTap: () {},
                        suffixIcon: const Icon(Icons.verified_user),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
