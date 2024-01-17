import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/providers/lessons.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';

class CourseDiscussionPage extends HookWidget {
  final String className;

  CourseDiscussionPage(this.className);
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _comment = useState<String?>(null);
    final _isLoading = useState(false);

    final _sendComment = useMemoized(
        () => () async {
              if (!_formKey.value.currentState!.validate()) {
                return;
              }
              _formKey.value.currentState?.save();
              print(_comment.value);

              _isLoading.value = true;

              try {
                await context.read(lessonProvider.notifier).sendComment(
                      context.read(hasuraClientProvider).state,
                      _comment.value ??
                          '', // Provide an empty string as a default value
                    );

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
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      _isLoading.value
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: _sendComment,
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
                          color: Color(0xFFF5F0FC),
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
                              '$className',
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
                          _comment.value = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Komentar tidak boleh kosong';
                          }
                        },
                        onFieldSubmitted: (value) {
                          _sendComment();
                        },
                        textEditingController: TextEditingController(),
                        initialValue: '',
                        focusNode: FocusNode(),
                        onChanged: (string) {},
                        onTap: () {},
                        // suffixIcon: Container(),
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
