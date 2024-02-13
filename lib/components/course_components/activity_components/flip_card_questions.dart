import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_tindercard/flutter_tindercard.dart';
// import 'package:flutter_tindercard_plus/flutter_tindercard_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/providers/questions.dart';

class FlipCardQuestions extends HookWidget {
  final ValueNotifier<bool> isStart;
  final Function(bool) saveAnswer;

  FlipCardQuestions(this.isStart, this.saveAnswer);
  @override
  Widget build(BuildContext context) {
    print(isStart.value);
    final indexHolder = useState(0);

    final questions =
        useState<List<Pertanyaan>>(context.read(questionProvider));

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          SizeTransition(child: child, sizeFactor: animation),
      //   child: isStart.value
      //       ? Container(
      //           key: ValueKey<bool>(true),
      //           height: 343,
      //           child: indexHolder.value == questions.value.length
      //               ? Center(
      //                   child: CircularProgressIndicator(
      //                   valueColor: AlwaysStoppedAnimation(Colors.white),
      //                 ))
      //               : TinderSwapCard(
      //                   swipeUp: false,
      //                   swipeDown: false,
      //                   orientation: AmassOrientation.top,
      //                   allowVerticalMovement: false,
      //                   totalNum: questions.value.length,
      //                   stackNum: 3,
      //                   swipeEdge: 4.0,
      //                   maxWidth: MediaQuery.of(context).size.width * 0.9,
      //                   maxHeight: MediaQuery.of(context).size.width * 0.9,
      //                   minWidth: MediaQuery.of(context).size.width * 0.8,
      //                   minHeight: MediaQuery.of(context).size.width * 0.8,
      //                   cardBuilder: (context, index) => AnimatedContainer(
      //                     // key: index == indexHolder.value ? ValueKey(index) : null,
      //                     duration: Duration(milliseconds: 500),

      //                     margin: EdgeInsets.only(
      //                         top: index == indexHolder.value
      //                             ? 24
      //                             : index == indexHolder.value + 1
      //                                 ? 12
      //                                 : 0),
      //                     decoration: BoxDecoration(
      //                       color: index == indexHolder.value
      //                           ? Colors.white
      //                           : index == indexHolder.value + 1
      //                               ? Colors.white.withOpacity(0.5)
      //                               : Colors.white.withOpacity(0.25),
      //                       borderRadius: BorderRadius.circular(12),
      //                     ),
      //                     padding: const EdgeInsets.all(20),
      //                     child: index == indexHolder.value
      //                         ? Center(
      //                             child: Text(
      //                               questions.value[index].isiPertanyaan,
      //                               textAlign: TextAlign.center,
      //                               style: Theme.of(context).textTheme.titleLarge,
      //                             ),
      //                           )
      //                         : Container(),
      //                   ),
      //                   swipeCompleteCallback:
      //                       (CardSwipeOrientation orientation, int index) {
      //                     if (orientation == CardSwipeOrientation.right) {
      //                       indexHolder.value += 1;
      //                       saveAnswer(true);
      //                     }

      //                     if (orientation == CardSwipeOrientation.left) {
      //                       indexHolder.value += 1;
      //                       saveAnswer(false);
      //                     }

      //                     /// Get orientation & index of swiped card!
      //                   },
      //                 ),
      //         )
      //       : Container(
      //           key: ValueKey<bool>(false),
      //         ),
    );
  }
}
