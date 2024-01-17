import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/list_item/icon_card_item.dart';
import 'package:sekopercinta/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta/components/tool_tip/tool_tip_container.dart';
import 'package:sekopercinta/page/course_pages/course_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseProfile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _isLoading = useState(false);
    final _userData = useState<UserData>(context.read(userDataProvider));

    final _getUserData = useMemoized(
        () => () async {
              if (context.read(authProvider.notifier).isAuth) {
                if (_userData.value.namaPengguna == null) {
                  _isLoading.value = true;
                }

                try {
                  await context.read(userDataProvider.notifier).getUserData(
                        context.read(hasuraClientProvider).state,
                      );
                  _userData.value = context.read(userDataProvider);
                } catch (error) {
                  _isLoading.value = false;
                  throw error;
                }
                _isLoading.value = false;
              }
            },
        []);

    useEffect(() {
      _getUserData();
      return;
    }, []);
    return _isLoading.value
        ? Column(
            children: [
              Row(
                children: [
                  ShimmerCard(height: 52, width: 52, borderRadius: 12),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerCard(height: 15, width: 131, borderRadius: 4),
                        const SizedBox(
                          height: 4,
                        ),
                        ShimmerCard(height: 15, width: 131, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
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
                      child:
                          _userData.value.fotoProfil.toString().contains('http')
                              ? Image.network(
                                  '${_userData.value.fotoProfil}',
                                  fit: BoxFit.cover,
                                  height: 52,
                                )
                              : Image.asset(
                                  _userData.value.fotoProfil == '{{default_1}}'
                                      ? 'assets/images/img-women-a.png'
                                      : _userData.value.fotoProfil ==
                                              '{{default_2}}'
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
                          _userData.value.namaPengguna ?? 'Peserta',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: primaryVeryDarkColor,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          _userData.value.email,
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
                  // InkWell(
                  //   onTap: () {},
                  //   child: Image.asset(
                  //     'assets/images/ic-notif.png',
                  //     width: 24,
                  //   ),
                  // ),
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
                        // InkWell(
                        //   onTap: () {
                        //     showModalBottomSheet(
                        //       context: context,
                        //       isScrollControlled: true,
                        //       backgroundColor: Colors.transparent,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(12),
                        //           topLeft: Radius.circular(12),
                        //         ),
                        //       ),
                        //       builder: (context) => TimeLineBottomSheet(),
                        //     );
                        //   },
                        //   child: Image.asset(
                        //     'assets/images/ic-help.png',
                        //     width: 18,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
