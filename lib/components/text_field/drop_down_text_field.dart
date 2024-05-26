import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class DropDownTextField extends HookWidget {
  final ValueNotifier<String> value;
  final String hint;
  final List<String> listString;
  final Function(String?) onSaved;
  final Function(String?) validator;
  // final Function(String?) validator = myValidator;

  const DropDownTextField({
    super.key,
    required this.value,
    required this.hint,
    required this.listString,
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Biennale',
            fontWeight: FontWeight.w500,
          ),
          iconEnabledColor: accentColor,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(),
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding:
                const EdgeInsets.only(left: 16, bottom: 8, top: 8, right: 16),
            labelText: hint,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Biennale',
            ),
          ),
          value: value.value,
          iconSize: 24,
          elevation: 16,
          onChanged: (String? newValue) {
            if (newValue != null) {
              value.value = newValue;
            }
          },
          // validator: validator,
          validator: validator as String? Function(String?)? ??
              (String? value) => null,
          items: listString.isEmpty
              ? null
              : listString.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Color(0xFF585858)),
                      ),
                    );
                  },
                ).toList(),
          onSaved: onSaved,
        ),
      ),
    );
  }
}
