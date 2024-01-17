import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/page/camera_page/camera_page.dart';
import 'package:sekopercinta/providers/activities.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/file_upload_handler.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class AddPostPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _postDescription = useState<String?>(null);
    final _isLoading = useState(false);
    final _selectedFile = useState<File?>(null);

    final _addPost = useMemoized(
        () => () async {
              if (_selectedFile.value == null) {
                Fluttertoast.showToast(
                  msg: 'Mohon masukkan foto',
                );
              }

              if (!_formKey.value.currentState!.validate()) {
                return;
              }
              _formKey.value.currentState?.save();
              print(_postDescription.value);

              _isLoading.value = true;

              try {
                await context
                    .read(activityProvider.notifier)
                    .sendCommunityImage(
                      file: _selectedFile.value!,
                      comment: _postDescription.value!,
                      hasuraConnect: context.read(hasuraClientProvider).state,
                    );

                _isLoading.value = false;
                Navigator.of(context).pop(true);
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
            },
        []);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey.value,
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
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      _isLoading.value
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: _addPost,
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
                          color: Color(0xFFF5F0FC),
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
                              if (await Permission.camera.request().isGranted) {
                                final selectedFilePath =
                                    await Navigator.of(context)
                                        .push(createRoute(page: CameraPage()));

                                if (selectedFilePath != null) {
                                  _selectedFile.value = File(selectedFilePath);
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

                                  _selectedFile.value = file;
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
                              color: Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(14),
                              image: _selectedFile.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        _selectedFile.value!,
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
                                        color: _selectedFile.value == null
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
                                        color: _selectedFile.value == null
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
                          _postDescription.value = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Deskripsi post tidak boleh kosong';
                          }
                        },
                        onFieldSubmitted: (value) {
                          _addPost();
                        },
                        textEditingController: TextEditingController(),
                        initialValue: '',
                        focusNode: FocusNode(),
                        onChanged: (string) {},
                        onTap: () {},
                        suffixIcon: Icon(Icons.verified_user),
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
