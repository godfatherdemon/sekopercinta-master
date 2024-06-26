import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class BorderedFormField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final TextEditingController textEditingController;
  final String initialValue;
  final int maxLine;
  final FocusNode focusNode;
  final Function(String) onFieldSubmitted;
  final Function(String?) onChanged;
  final Function(String) onSaved;
  // final Function(String) validator;
  final String? Function(String?)?
      validator; // Changed to accept nullable string
  final Function onTap;
  final Widget suffixIcon;

  const BorderedFormField({
    super.key,
    required this.hint,
    required this.textEditingController,
    required this.initialValue,
    required this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    required this.onFieldSubmitted,
    required this.maxLine,
    required this.onChanged,
    required this.onSaved,
    required this.onTap,
    required this.validator,
    required this.suffixIcon,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onTap: onTap,
      onTap: onTap as void Function()? ?? () {},
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: textEditingController,
      initialValue: initialValue,
      focusNode: focusNode,
      maxLines: maxLine,
      style: const TextStyle(
        fontSize: 14,
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: accentColor, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        contentPadding:
            const EdgeInsets.only(left: 12, bottom: 12, top: 12, right: 12),
        labelText: hint,
        labelStyle: const TextStyle(
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      // onSaved: onSaved,
      onSaved: onSaved as void Function(String?)? ?? (String? value) {},
      validator: validator,
      // validator:
      //     validator as String? Function(String?)? ?? (String? value) => null,
    );
  }
}
