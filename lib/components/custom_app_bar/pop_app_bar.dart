import 'package:flutter/material.dart';
import 'package:sekopercinta/utils/constants.dart';

class PopAppBar extends StatelessWidget {
  final String title;
  final bool justTitle;
  final bool isBackIcon;
  final Widget action;
  final Function onPop;

  PopAppBar(
      {required this.title,
      // required this.action,
      this.action = const SizedBox(),
      // required this.onPop,
      this.onPop = _defaultOnPop,
      this.justTitle = false,
      this.isBackIcon = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!justTitle)
              IconButton(
                icon: Icon(
                  isBackIcon ? Icons.arrow_back_ios : Icons.close,
                  color: justTitle ? Colors.transparent : primaryBlack,
                ),
                // onPressed: justTitle
                //     ? null
                //     : onPop == null
                //         ? () => Navigator.of(context).pop()
                //         : onPop,
                // onPressed: onPop == null
                //     ? () => Navigator.of(context).pop()
                //     : () => onPop!(),
                onPressed: () => onPop(),
              ),
            Text(
              title,
              style: TextStyle(
                color: primaryBlack,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            // if (action != null)
            // ? IconButton(
            //     icon: Icon(
            //       Icons.arrow_back_ios_rounded,
            //       color: Colors.transparent,
            //     ),
            //     onPressed: null,
            //   )
            // :
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: action,
            ),
          ],
        ),
      ),
    );
  }
}

void _defaultOnPop() {
  // Default function that does nothing
}
