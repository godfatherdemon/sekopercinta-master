import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/bordered_button.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class AnswerManyQuestions extends HookWidget {
  final ValueNotifier<bool> isStart;
  final ValueNotifier<List<String>> answers;
  final Function finish;

  AnswerManyQuestions({
    required this.isStart,
    required this.answers,
    required this.finish,
  });
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _listKey = useState(GlobalKey<AnimatedListState>());

    final _answerTextEditingController = useTextEditingController();

    return Form(
      key: _formKey.value,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            SizeTransition(child: child, sizeFactor: animation),
        child: isStart.value
            ? Padding(
                key: ValueKey<bool>(true),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Divider(
                      color: Color(0xFFEEEEEE).withOpacity(0.3),
                    ),
                    SizedBox(
                      height: 200,
                      child: AnimatedList(
                        key: _listKey.value,
                        initialItemCount: 0,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
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
                                      style: TextStyle(
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
                      color: Color(0xFFEEEEEE).withOpacity(0.3),
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
                          BorderedFormField(
                            hint: 'Jawaban',
                            textEditingController: _answerTextEditingController,
                            onSaved: (value) async {
                              answers.value.add(value);
                              print(answers.value);
                              // await Future.delayed(Duration(milliseconds: 200));
                              _listKey.value.currentState?.insertItem(
                                0,
                                duration: Duration(milliseconds: 300),
                              );

                              _answerTextEditingController.text = '';
                            },
                            validator: (value) {
                              if (answers.value.contains(value)) {
                                return 'Jawaban tidak boleh ada yang sama';
                              }
                              if (value.isEmpty) {
                                return 'Jawaban tidak boleh kosong';
                              }
                            },
                            initialValue: '',
                            focusNode: FocusNode(),
                            onFieldSubmitted: (string) {},
                            maxLine: 999,
                            onChanged: (string) {},
                            onTap: () {
                              print('BorderedFormField tapped!');
                            },
                            suffixIcon: Container(),
                          )
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
                        if (!_formKey.value.currentState!.validate()) {
                          return;
                        }
                        _formKey.value.currentState?.save();

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
                key: ValueKey<bool>(false),
              ),
      ),
    );
  }
}
