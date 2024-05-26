import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/course_components/time_line_bottom_sheet.dart';
import 'package:sekopercinta_master/components/list_item/icon_card_item.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/components/tool_tip/tool_tip_container.dart';
import 'package:sekopercinta_master/page/course_pages/course_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseProfile extends HookWidget {
  const CourseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final userData = useState<UserData>(context.read(userDataProvider));

    final getUserData = useMemoized(
        () => () async {
              if (context.read(authProvider.notifier).isAuth) {
                if (userData.value.namaPengguna == null) {
                  isLoading.value = true;
                }

                try {
                  await context.read(userDataProvider.notifier).getUserData(
                        context.read(hasuraClientProvider).state,
                      );
                  // userData.value = context.read(userDataProvider);
                  userData.value = userDataProvider as UserData;
                } catch (error) {
                  isLoading.value = false;
                  rethrow;
                }
                isLoading.value = false;
              }
            },
        []);

    useEffect(() {
      getUserData();
      return;
    }, []);
    return isLoading.value
        ? const Column(
            children: [
              Row(
                children: [
                  ShimmerCard(height: 52, width: 52, borderRadius: 12),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerCard(height: 15, width: 131, borderRadius: 4),
                        SizedBox(
                          height: 4,
                        ),
                        ShimmerCard(height: 15, width: 131, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              ShimmerCard(
                height: 70,
                width: double.infinity,
                borderRadius: 10,
              ),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  IconItemCard(
                    width: 52,
                    height: 52,
                    gradient: gradientPrimary,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: userData.value.fotoProfil
                              .toString()
                              .contains('http')
                          ? Image.network(
                              '${userData.value.fotoProfil}',
                              fit: BoxFit.cover,
                              height: 52,
                            )
                          : Image.asset(
                              userData.value.fotoProfil == '{{default_1}}'
                                  ? 'assets/images/img-women-a.png'
                                  : userData.value.fotoProfil == '{{default_2}}'
                                      ? 'assets/images/img-women-b.png'
                                      : 'assets/images/img-women-c.png',
                              fit: BoxFit.cover,
                              height: 32,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.value.namaPengguna ?? 'Peserta',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: primaryVeryDarkColor,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          userData.value.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: primaryVeryDarkColor.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/ic-notif.png',
                      width: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ToolTipContainer(
                title: 'Angkatan Anda',
                description:
                    'Selesaikan seluruh kelas Anda, dan ikuti wisuda pada masa berakhir angkatan Anda.',
                onButtonTap: () {
                  ShowCaseWidget.of(context)
                      .startShowCase([CourseTipKeys.courseTipKey2]);
                },
                step: 1,
                key: GlobalKey<State<StatefulWidget>>(),
                child: Card(
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Angkatan',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: primaryDarkColor,
                                    ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                '${DateTime.now().year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Berakhir Pada',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: primaryDarkColor,
                                    ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Desember',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
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
                              builder: (context) => const TimeLineBottomSheet(),
                            );
                          },
                          child: Image.asset(
                            'assets/images/ic-help.png',
                            width: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
