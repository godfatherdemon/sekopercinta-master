import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/utils/constants.dart';

class FilterMyActivityBottomSheet extends HookWidget {
  @override
  Widget build(BuildContext context) {
    String _selectedDate = '';
    final _isLastMonth = useState(true);
    final _filterTextEditingController = useTextEditingController();
    final _animationController = useAnimationController(
      duration: Duration(milliseconds: 300),
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
                  color: Color(0xFFE0E0E0),
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
                      color: Color(0xFFA2A1A1),
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              RadioListTile(
                value: true,
                groupValue: _isLastMonth.value,
                onChanged: (value) {
                  if (value is bool) {
                    _isLastMonth.value = value;
                    _animationController.reverse();
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
                groupValue: _isLastMonth.value,
                onChanged: (value) {
                  if (value is bool) {
                    _isLastMonth.value = value;
                    _animationController.forward();
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
                sizeFactor: _animationController,
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
                          _filterTextEditingController.text =
                              DateFormat('yyyy-MM-dd').format(picked);
                        }
                      },
                      child: IgnorePointer(
                        child: BorderedFormField(
                          hint: 'Pilih Tanggal',
                          textEditingController: _filterTextEditingController,
                          initialValue: '',
                          focusNode: FocusNode(),
                          maxLine: 1,
                          onChanged: (value) {
                            print('Field value changed to: $value');
                          },
                          onSaved: (value) {
                            _selectedDate = value; // Update the selected date
                            print('Selected Date: $_selectedDate');
                            _isLastMonth.value = value
                                .isEmpty; // Update _isLastMonth based on the selected date
                          },
                          onTap: (value) {
                            print('Field value changed to: $value');
                            // print('Field tapped');
                          },
                          onFieldSubmitted: (value) {},
                          suffixIcon: Container(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: Image.asset(
                                'assets/images/ic-calendar.png',
                                width: 24,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tanggal tidak boleh kosong';
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
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
