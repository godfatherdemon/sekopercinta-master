import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/providers/attachments.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class CourseAttachmentTab extends HookWidget {
  const CourseAttachmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final attachments =
        useState<List<Lampiran>>(context.read(attachmentProvider));

    final isLoading = useState(false);

    final getAttachments = useMemoized(
        () => () async {
              try {
                isLoading.value = true;

                // final lessonId = context.read(lessonProvider).idPelajaran;
                // final hasuraClient = context.read(hasuraClientProvider).state;

                // final attachmentNotifier =
                //     context.read(attachmentProvider.notifier);

                await context.read(attachmentProvider.notifier).getAttachments(
                      context.read(lessonProvider).idPelajaran,
                      context.read(hasuraClientProvider).state,
                    );

                // await context.read(attachmentProvider.notifier).getAttachments(
                //       lessonId,
                //       hasuraClient,
                //     );

                // attachments.value = context.read(attachmentProvider);
                attachments.value = attachmentProvider as List<Lampiran>;
              } catch (error) {
                isLoading.value = false;
                rethrow;
              } finally {
                isLoading.value = false;
              }
              // isLoading.value = false;
            },
        []);

    useEffect(() {
      getAttachments();

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
                'File dan Dokumen',
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
                'File pendukung untuk anda unduh dan gunakan',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 18,
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
                    itemCount: attachments.value.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shadowColor: secondaryColor.withOpacity(0.24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0EDEB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/ic-${attachments.value[index].jenisLampiran}.png',
                                      width: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        attachments.value[index].namaLampiran,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        'Download File',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: accentColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            if (attachments.value.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      Image.asset(
                        'assets/images/ic-empty-file.png',
                        width: 112,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      Text(
                        'Tidak ada Lampiran',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF4F4F4F),
                                ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Kelas ini tidak memiliki lampiran untuk Anda unduh.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
