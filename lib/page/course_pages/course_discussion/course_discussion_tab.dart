import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/course_pages/course_discussion/course_discussion_page.dart';
import 'package:sekopercinta_master/providers/discussions.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class CourseDiscussionTab extends HookWidget {
  final Pelajaran lesson;
  const CourseDiscussionTab(this.lesson, {super.key});

  @override
  Widget build(BuildContext context) {
    final discussions =
        useState<List<Diskusi>>(context.read(discussionsProvider));

    // final _discussions = useProvider(discussionsProvider);

    final userData = useState<UserData>(context.read(userDataProvider));

    final isLoading = useState(false);

    final getDiscussions = useMemoized(
        () => () async {
              try {
                isLoading.value = true;

                await context.read(discussionsProvider.notifier).getDiscussions(
                      lesson.idPelajaran,
                      context.read(hasuraClientProvider).state,
                    );
                // discussions.value = context.read(discussionsProvider);
                discussions.value = discussionsProvider as List<Diskusi>;
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }
              isLoading.value = false;
            },
        []);

    useEffect(() {
      getDiscussions();

      return;
    }, []);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Diskusi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryVeryDarkColor,
                    ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Tanyakan semua yang berkaitan dengan kelas',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                final isSendComment = await Navigator.of(context).push(
                  createRoute(
                      page: CourseDiscussionPage(lesson.namaPelajaran),
                      isVertical: true),
                );

                if (isSendComment != null) {
                  getDiscussions();
                }
              },
              child: Ink(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: gradientPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: userData.value.fotoProfil
                              .toString()
                              .contains('http')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${userData.value.fotoProfil}',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              userData.value.fotoProfil == '{{default_1}}'
                                  ? 'assets/images/img-women-a.png'
                                  : userData.value.fotoProfil == '{{default_2}}'
                                      ? 'assets/images/img-women-b.png'
                                      : 'assets/images/img-women-c.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      'Tulis Komentar',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            isLoading.value
                ? ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      return const ShimmerCard(
                          height: 80, width: double.infinity, borderRadius: 12);
                    },
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemCount: discussions.value.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    gradient: gradientD,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: discussions.value[index]
                                              .profilPublik.fotoProfil
                                              .contains('http')
                                          ? NetworkImage(discussions
                                              .value[index]
                                              .profilPublik
                                              .fotoProfil)
                                          : AssetImage(
                                              discussions
                                                          .value[index]
                                                          .profilPublik
                                                          .fotoProfil ==
                                                      '{{default_1}}'
                                                  ? 'assets/images/img-women-a.png'
                                                  : discussions
                                                              .value[index]
                                                              .profilPublik
                                                              .fotoProfil ==
                                                          '{{default_2}}'
                                                      ? 'assets/images/img-women-b.png'
                                                      : 'assets/images/img-women-c.png',
                                            ) as ImageProvider<Object>,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${discussions.value[index].profilPublik.namaPengguna}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          Text(
                                            '${DateFormat('MMM dd, yyyy').format(discussions.value[index].dikirimPada)} at ${DateFormat('hh:mm a').format(discussions.value[index].dikirimPada)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 13.5),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: (discussions
                                            .value[index]
                                            .balasanDiskusiPelajarans
                                            .isNotEmpty)
                                        ? const Color(0xFF4D4FF1)
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    width: 2.9,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                discussions.value[index].isiDiskusi,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            if (discussions.value[index]
                                .balasanDiskusiPelajarans.isNotEmpty)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13.0),
                                    child: Image.asset(
                                      'assets/images/ic-admin-response-arrow.png',
                                      width: 27,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 26,
                                              width: 26,
                                              decoration: BoxDecoration(
                                                gradient: gradientD,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/img-women-a.png'),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 14,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Admin',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      Text(
                                                        '${DateFormat('MMM dd, yyyy').format(discussions.value[index].balasanDiskusiPelajarans[0].dikirimPada)} at ${DateFormat('hh:mm a').format(discussions.value[index].balasanDiskusiPelajarans[0].dikirimPada)}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    discussions
                                                        .value[index]
                                                        .balasanDiskusiPelajarans[
                                                            0]
                                                        .isiBalasan,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
            if (discussions.value.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      Image.asset(
                        'assets/images/ic-empty-discussion.png',
                        width: 112,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      Text(
                        'Mulai Berdiskusi!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF4F4F4F),
                                ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Belum ada diskusi terkait kelas ini. Jadilah yang pertama bertanya, memberi saran, dan berkomentar!',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF4F4F4F),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
