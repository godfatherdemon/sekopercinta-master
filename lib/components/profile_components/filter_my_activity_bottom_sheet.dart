import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class FilterMyActivityBottomSheet extends HookWidget {
  const FilterMyActivityBottomSheet({super.key});
  // final TextEditingController _filterTextEditingController =
  //     TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String selectedDate = '';
  // ValueNotifier<bool> isLastMonth = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _filterTextEditingController =
        TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    ValueNotifier<bool> isLastMonth = ValueNotifier<bool>(false);
    String selectedDate = '';
    // final isLastMonth = useState(true);
    final filterTextEditingController = useTextEditingController();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: 0,
    );
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Filter Aktivitas Saya',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryVeryDarkColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Pilih tanggal untuk melihat aktivitas',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFA2A1A1),
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              RadioListTile(
                value: true,
                groupValue: isLastMonth.value,
                onChanged: (value) {
                  if (value is bool) {
                    isLastMonth.value = value;
                    animationController.reverse();
                  }
                  // _isLastMonth.value = value;
                  // _animationController.reverse();
                },
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  '30 Hari Terakhir',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              RadioListTile(
                value: false,
                groupValue: isLastMonth.value,
                onChanged: (value) {
                  if (value is bool) {
                    isLastMonth.value = value;
                    animationController.forward();
                  }
                  // _isLastMonth.value = value;
                  // _animationController.forward();
                },
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  'Pilih Tanggal Sendiri',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizeTransition(
                sizeFactor: animationController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          filterTextEditingController.text =
                              DateFormat('yyyy-MM-dd').format(picked);
                        }
                      },
                      child: Column(
                        children: [
                          IgnorePointer(
                            child: TextFormField(
                              controller: _filterTextEditingController,
                              decoration: InputDecoration(
                                hintText: 'Pilih Tanggal',
                                border: const OutlineInputBorder(),
                                suffixIcon: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/ic-calendar.png',
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ),
                              focusNode: FocusNode(),
                              maxLines: 1,
                              onChanged: (value) {
                                final Logger logger = Logger();
                                logger.d('Field value changed to: $value');
                              },
                              onSaved: (value) {
                                selectedDate = value!;
                                final Logger logger = Logger();
                                logger.d('Selected Date: $selectedDate');
                                isLastMonth.value = value.isEmpty;
                              },
                              onTap: () {
                                final Logger logger = Logger();
                                logger.d('Field tapped');
                              },
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Tanggal tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            // SizedBox(height: 16),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     if (_formKey.currentState!.validate()) {
                            //       _formKey.currentState!.save();
                            //       // Implement the logic to handle the saved date
                            //       print('Selected Date: $selectedDate');
                            //     }
                            //   },
                            //   child: Text('Submit'),
                            // ),

                            // child: BorderedFormField(
                            //   hint: 'Pilih Tanggal',
                            //   textEditingController:
                            //       filterTextEditingController,
                            //   initialValue: '',
                            //   focusNode: FocusNode(),
                            //   maxLine: 1,
                            //   onChanged: (value) {
                            //     // print('Field value changed to: $value');
                            //     final Logger logger = Logger();
                            //     logger.d('Field value changed to: $value');
                            //   },
                            //   onSaved: (value) {
                            //     selectedDate =
                            //         value; // Update the selected date
                            //     final Logger logger = Logger();
                            //     logger.d('Selected Date: $selectedDate');
                            //     isLastMonth.value = value
                            //         .isEmpty; // Update _isLastMonth based on the selected date
                            //   },
                            //   onTap: (value) {
                            //     final Logger logger = Logger();
                            //     logger.d('Field value changed to :$value');
                            //   },
                            //   onFieldSubmitted: (value) {},
                            //   suffixIcon: SizedBox(
                            //     width: 32,
                            //     height: 32,
                            //     child: Center(
                            //       child: Image.asset(
                            //         'assets/images/ic-calendar.png',
                            //         width: 24,
                            //       ),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'Tanggal tidak boleh kosong';
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Implement the logic to handle the saved date
                          print('Selected Date: $selectedDate');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: FillButton(
                      text: 'Kembali',
                      color: brokenWhite,
                      textColor: primaryBlack,
                      onTap: () => Navigator.of(context).pop(),
                      leading: Container(),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: FillButton(
                      text: 'Terapkan',
                      onTap: () => Navigator.of(context).pop(),
                      leading: Container(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
