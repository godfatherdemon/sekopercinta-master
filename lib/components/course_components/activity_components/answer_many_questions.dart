import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/custom_button/bordered_button.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class AnswerManyQuestions extends HookWidget {
  final ValueNotifier<bool> isStart;
  final ValueNotifier<List<String>> answers;
  final Function finish;

  const AnswerManyQuestions({
    super.key,
    required this.isStart,
    required this.answers,
    required this.finish,
  });
  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final listKey = useState(GlobalKey<AnimatedListState>());

    final answerTextEditingController = useTextEditingController();

    return Form(
      key: formKey.value,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            SizeTransition(sizeFactor: animation, child: child),
        child: isStart.value
            ? Padding(
                key: const ValueKey<bool>(true),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Divider(
                      color: const Color(0xFFEEEEEE).withOpacity(0.3),
                    ),
                    SizedBox(
                      height: 200,
                      child: AnimatedList(
                        key: listKey.value,
                        initialItemCount: 0,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index, animation) {
                          return FadeTransition(
                            key: Key('$index'),
                            opacity: animation,
                            child: SlideTransition(
                              position: animation.drive(Tween<Offset>(
                                end: Offset.zero,
                                begin: const Offset(0.0, 0.1),
                              )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      answers.value[
                                          answers.value.length - 1 - index],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: const Color(0xFFEEEEEE).withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Tuliskan jawaban Anda',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // BorderedFormField(
                          //   hint: 'Jawaban',
                          //   textEditingController: answerTextEditingController,
                          //   onSaved: (value) async {
                          //     answers.value.add(value);
                          //     // print(answers.value);
                          //     final Logger logger = Logger();
                          //     logger.d(answers.value);
                          //     // await Future.delayed(Duration(milliseconds: 200));
                          //     listKey.value.currentState?.insertItem(
                          //       0,
                          //       duration: const Duration(milliseconds: 300),
                          //     );

                          //     answerTextEditingController.text = '';
                          //   },
                          //   validator: (value) {
                          //     if (answers.value.contains(value)) {
                          //       return 'Jawaban tidak boleh ada yang sama';
                          //     }
                          //     if (value!.isEmpty) {
                          //       return 'Jawaban tidak boleh kosong';
                          //     }
                          //     return null;
                          //   },
                          //   initialValue: '',
                          //   focusNode: FocusNode(),
                          //   onFieldSubmitted: (string) {},
                          //   maxLine: 999,
                          //   onChanged: (string) {},
                          //   onTap: () {
                          //     // print('BorderedFormField tapped!');
                          //     final Logger logger = Logger();
                          //     logger.d('BorderedFormField tapped!');
                          //   },
                          //   suffixIcon: Container(),
                          // )
                          TextFormField(
                            controller: answerTextEditingController,
                            decoration: InputDecoration(
                              hintText: 'Jawaban',
                              border: const OutlineInputBorder(),
                              suffixIcon:
                                  Container(), // Add any specific widget if needed
                            ),
                            onSaved: (value) async {
                              answers.value
                                  .add(value!); // Ensure non-null value
                              final Logger logger = Logger();
                              logger.d(answers.value);
                              listKey.value.currentState?.insertItem(
                                0,
                                duration: const Duration(milliseconds: 300),
                              );
                              answerTextEditingController.clear();
                            },
                            validator: (value) {
                              if (answers.value.contains(value)) {
                                return 'Jawaban tidak boleh ada yang sama';
                              }
                              if (value == null || value.isEmpty) {
                                return 'Jawaban tidak boleh kosong';
                              }
                              return null;
                            },
                            focusNode: FocusNode(),
                            maxLines: null, // To allow multiple lines
                            onFieldSubmitted: (value) {
                              // Implement any specific logic on field submission if needed
                            },
                            onChanged: (value) {
                              // Implement any specific logic on field change if needed
                            },
                            onTap: () {
                              final Logger logger = Logger();
                              logger.d('TextFormField tapped!');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FillButton(
                      textColor: accentColor,
                      color: Colors.white,
                      text: 'Tambahkan',
                      onTap: () {
                        if (!formKey.value.currentState!.validate()) {
                          return;
                        }
                        formKey.value.currentState?.save();

                        answers.value = [...answers.value];
                      },
                      leading: Container(),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    BorderedButton(
                      textColor: Colors.white,
                      color: Colors.white,
                      text: 'Selesai',
                      onTap: () {
                        if (answers.value.isNotEmpty) {
                          finish();
                        }
                      },
                      leading: Container(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Container(
                key: const ValueKey<bool>(false),
              ),
      ),
    );
  }
}
