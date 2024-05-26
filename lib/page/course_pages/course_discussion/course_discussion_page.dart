import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class CourseDiscussionPage extends HookWidget {
  final String className;

  const CourseDiscussionPage(this.className, {super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final comment = useState<String?>(null);
    final isLoading = useState(false);

    final sendComment = useMemoized(
        () => () async {
              final navigator = Navigator.of(context);
              if (!formKey.value.currentState!.validate()) {
                return;
              }
              formKey.value.currentState?.save();
              // print(comment.value);
              final Logger logger = Logger();
              logger.d(comment.value);

              isLoading.value = true;

              try {
                await context.read(lessonProvider.notifier).sendComment(
                      context.read(hasuraClientProvider).state,
                      comment.value ??
                          '', // Provide an empty string as a default value
                    );

                // Navigator.of(context).pop(true);
                navigator.pop('edit');
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
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      isLoading.value
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: sendComment,
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
                                  'Kirim',
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
                              'Nama Kelas',
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
                              className,
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
                      BorderedFormField(
                        hint: 'Tulis komentar Anda....',
                        keyboardType: TextInputType.multiline,
                        maxLine: 7,
                        onSaved: (value) {
                          comment.value = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Komentar tidak boleh kosong';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          sendComment();
                        },
                        textEditingController: TextEditingController(),
                        initialValue: '',
                        focusNode: FocusNode(),
                        onChanged: (string) {},
                        onTap: () {},
                        // suffixIcon: Container(),
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
