import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class EssayQuestionCard extends HookWidget {
  final Function nextQuestion;
  final Function prevQuestion;
  final Function(String) saveAnswer;
  final ValueNotifier<int> currentQuestion;

  EssayQuestionCard({
    required this.nextQuestion,
    required this.prevQuestion,
    required this.saveAnswer,
    required this.currentQuestion,
  });
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    return Form(
      key: _formKey.value,
      child: Column(
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
                      'Tuliskan jawaban Anda',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    BorderedFormField(
                      hint: 'Menurut saya ... ',
                      keyboardType: TextInputType.multiline,
                      maxLine: 7,
                      onSaved: (value) {
                        saveAnswer(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Jawaban tidak boleh kosong';
                        }
                      },
                      textEditingController: TextEditingController(),
                      initialValue: '',
                      focusNode: FocusNode(),
                      onFieldSubmitted: (string) {},
                      onChanged: (string) {},
                      onTap: () {},
                      suffixIcon: Container(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Batas karakter adalah 420 karakter',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: primaryGrey,
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
                    if (!_formKey.value.currentState!.validate()) {
                      return;
                    }
                    _formKey.value.currentState?.save();
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
      ),
    );
  }
}
