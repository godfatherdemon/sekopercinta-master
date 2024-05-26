import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/course_list.dart';
import 'package:sekopercinta_master/components/course_components/course_profile.dart';
import 'package:sekopercinta_master/components/course_components/facilitator_bottom_sheet.dart';
import 'package:sekopercinta_master/components/floating_widget/floating_button_facilitator.dart';
import 'package:sekopercinta_master/components/tool_tip/tool_tip_container.dart';
import 'package:sekopercinta_master/page/auth_pages/login_first_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/classes.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseTipKeys {
  static final courseTipKey1 = GlobalKey();
  static final courseTipKey2 = GlobalKey();
  static final courseTipKey3 = GlobalKey();
}

class CoursePage extends StatelessWidget {
  final ValueNotifier<int> _activeIndex;
  const CoursePage(this._activeIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return !context.read(authProvider.notifier).isAuth
        ? LoginFirstPage(_activeIndex)
        : Scaffold(
            backgroundColor: backgroundColor,
            body: ShowCaseWidget(
              builder: Builder(builder: (context) => const CoursePageContent()),
            ),
          );
  }
}

class CoursePageContent extends HookWidget {
  const CoursePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final refresh = useMemoized(
        () => () async {
              await context
                  .read(classProvider.notifier)
                  .getClasses(context.read(hasuraClientProvider).state);
            },
        []);

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -140,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg-blur.png',
              color: primaryColor,
              width: 241,
            ),
          ),
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CourseProfile(),
                      SizedBox(
                        height: 16,
                      ),
                      CourseList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FloatingButtonFacilitator(
            width: 96,
            height: 114,
            scrollController: scrollController,
            child: ToolTipContainer(
              title: 'Fasilitator Anda',
              description: 'Hubungi Fasilitator untuk memperoleh bantuan',
              step: 3,
              onButtonTap: () {
                ShowCaseWidget.of(context).dismiss();
                context.read(authProvider.notifier).setFirstTimeAccessCourse();
              },
              key: GlobalKey(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/fab-facilitator.png'),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                ),
                builder: (context) => const FacilitatorBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
