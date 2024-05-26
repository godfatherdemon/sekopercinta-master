import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/list_item/icon_card_item.dart';
import 'package:sekopercinta_master/components/tool_tip/tool_tip_container.dart';
import 'package:sekopercinta_master/page/course_pages/course_detail_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_page.dart';
import 'package:sekopercinta_master/providers/classes.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseListVocationItem extends StatelessWidget {
  final Kelas kelas;
  final Kelas prevKelas;
  final int classIndex;
  const CourseListVocationItem(this.kelas, this.prevKelas, this.classIndex,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: primaryColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modul ${kelas.modul.namaModul}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: primaryVeryDarkColor.withOpacity(0.5),
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              kelas.namaKelas,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryVeryDarkColor,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-paper.png',
                        color: primaryVeryDarkColor,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${kelas.pelajarans.length} Course',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: primaryVeryDarkColor,
                            ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic-peoples.png',
                        color: primaryVeryDarkColor,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${kelas.partisipanKelasAggregate.aggregate.count} Partisipan',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: primaryVeryDarkColor,
                            ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: kelas.pelajarans.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => functionPicker(context, index),
                child: Column(
                  children: [
                    (kelas.pelajarans[index].namaPelajaran !=
                            'Berkenalan dengan Sekoper Cinta')
                        ? Hero(
                            tag: kelas.pelajarans[index].logoPelajaran,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(0),
                              shadowColor: secondaryColor.withOpacity(0.24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Container(
                                  foregroundDecoration:
                                      getLessonDecoration(index),
                                  child: IconItemCard(
                                    width: 66,
                                    height: 66,
                                    gradient: gradients[index % 4],
                                    child: Image.network(
                                      kelas.pelajarans[index].logoPelajaran,
                                      width: 53.33,
                                    ),
                                    // child: kelas.pelajarans[index]
                                    //             .logoPelajaran !=
                                    //         null
                                    //     ? Image.network(
                                    //         kelas.pelajarans[index]
                                    //             .logoPelajaran,
                                    //         width: 53.33,
                                    //       )
                                    //     : SizedBox
                                    //         .shrink(), // Replace with any other widget or SizedBox.shrink() to have an empty space
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ToolTipContainer(
                            title: 'Kelas dan Modul',
                            description:
                                'Dalam tiap topik terdapat beberapa kelas. Klik disini dan mulai kelas pertama Anda!',
                            step: 2,
                            onButtonTap: () {
                              ShowCaseWidget.of(context)
                                  .startShowCase([CourseTipKeys.courseTipKey3]);
                            },
                            key: GlobalKey<State<StatefulWidget>>(),
                            child: Hero(
                              tag: kelas.pelajarans[index].logoPelajaran,
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(0),
                                shadowColor: secondaryColor.withOpacity(0.24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: IconItemCard(
                                    width: 66,
                                    height: 66,
                                    gradient: gradients[index],
                                    child: Image.network(
                                      kelas.pelajarans[index].logoPelajaran,
                                      width: 53.33,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      kelas.pelajarans[index].namaPelajaran,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: getLessonColor(index),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToDetail(BuildContext context, int index) {
    goToDetailCourse() {
      Navigator.of(context).push(createRoute(
        page: const CourseDetailPage(),
        arguments: {
          'id': kelas.pelajarans[index].idPelajaran,
          'modul': kelas.modul.namaModul,
          'index': index % 3,
          'isLastLessons': index == (kelas.pelajarans.length - 1),
          'lesson_image': kelas.pelajarans[index].logoPelajaran,
          'tab_index': 2,
        },
      ));
    }

    context.read(changeTabIndexProvider).state = goToDetailCourse;

    Navigator.of(context).push(createRoute(
      page: const CourseDetailPage(),
      arguments: {
        'id': kelas.pelajarans[index].idPelajaran,
        'modul': kelas.modul.namaModul,
        'index': index,
        'isLastLessons': index == (kelas.pelajarans.length - 1),
        'lesson_image': kelas.pelajarans[index].logoPelajaran,
        'tab_index': 0,
      },
    ));
  }

  void functionPicker(BuildContext context, int index) {
    goToDetail(context, index);
    (kelas.pelajarans[index].progresPelajarans.isEmpty)
        ? index == 0 && classIndex == 0
            ? goToDetail(context, index)
            : prevKelas.progresKelas.isEmpty
                ? null
                : index == 0
                    ? goToDetail(context, index)
                    : kelas.pelajarans[index - 1].progresPelajarans.isNotEmpty
                        ? goToDetail(context, index)
                        : null
        : goToDetail(context, index);
  }

  Color getLessonColor(int index) {
    return primaryVeryDarkColor;
  }

  Decoration? getLessonDecoration(int index) {
    return null;
  }
}
