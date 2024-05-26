import 'package:flutter/material.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class FillButton extends StatelessWidget {
  // final Function onTap;
  final VoidCallback onTap;
  final String text;
  final Color color;
  final Color textColor;
  final Widget leading;
  final bool isLoading;

  const FillButton({
    super.key,
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
          ? const Center(child: CircularProgressIndicator())
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
              // onPressed: onTap(),
              onPressed: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: leading,
                  ),

                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                  //  Expanded(
                  //     child: Text(
                  //       text,
                  //       textAlign: TextAlign.center,
                  //       maxLines: 2,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: TextStyle(
                  //         color: textColor,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
    );
  }
}
