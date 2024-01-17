import 'package:flutter/material.dart';
import 'package:sekopercinta/utils/constants.dart';

class BorderedButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color color;
  final Color textColor;
  final Widget leading;

  BorderedButton({
    required this.text,
    required this.onTap,
    required this.leading,
    this.color = const Color(0xFFD0CFC9),
    this.textColor = primaryBlack,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            side: MaterialStateProperty.resolveWith(
              (states) => BorderSide(color: color, width: 1),
            )),
        onPressed: onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (leading != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: leading,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
