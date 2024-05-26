import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/course_list_vocation_item.dart';
import 'package:sekopercinta_master/components/course_components/course_profile.dart';
import 'package:sekopercinta_master/components/course_components/facilitator_bottom_sheet.dart';
import 'package:sekopercinta_master/components/floating_widget/floating_button_facilitator.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/components/tool_tip/tool_tip_container.dart';
import 'package:sekopercinta_master/page/auth_pages/login_first_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/classes.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseVocationPage extends StatelessWidget {
  final ValueNotifier<int> _activeIndex;
  const CourseVocationPage(this._activeIndex, {super.key});

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

    final isLoading = useState(true);
    final classes = useProvider(classWatcher);

    useEffect(() {
      Future.delayed(Duration.zero).then((_) {
        context.read(moduleProvider).state = "Terampil";

        context
            .read(classProvider.notifier)
            .getClasses(context.read(hasuraClientProvider).state)
            .then((_) {
          isLoading.value = false;
        });
      });
      return;
    }, []);

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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CourseProfile(),
                      const SizedBox(
                        height: 16,
                      ),
                      isLoading.value
                          ? ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  const ShimmerCard(
                                height: 272,
                                width: double.infinity,
                                borderRadius: 10,
                              ),
                              separatorBuilder: (context, index) => Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: -50,
                                    right: -86,
                                    child: Image.asset(
                                      'assets/images/bg-blur.png',
                                      color: primaryColor,
                                      width: 191,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                              itemCount: 5,
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: classes.length,
                              itemBuilder: (context, index) =>
                                  CourseListVocationItem(
                                      classes[index],
                                      classes[index == 0 ? 0 : index - 1],
                                      index),
                              separatorBuilder: (context, index) => Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: -50,
                                    right: -86,
                                    child: Image.asset(
                                      'assets/images/bg-blur.png',
                                      color: primaryColor,
                                      width: 191,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
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
              key: GlobalKey<TooltipState>(),
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
