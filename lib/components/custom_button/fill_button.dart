import 'package:flutter/material.dart';
import 'package:sekopercinta/utils/constants.dart';

class FillButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color color;
  final Color textColor;
  final Widget leading;
  final bool isLoading;

  FillButton({
    required this.text,
    required this.onTap,
    required this.leading,
    this.color = accentColor,
    this.textColor = Colors.white,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => color,
                ),
              ),
              onPressed: onTap(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: leading,
                  ),
                  // ignore: unnecessary_null_comparison
                  (leading != null)
                      ? Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        )
                      : Expanded(
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
