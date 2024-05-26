import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class CourseIntroductionTab extends StatelessWidget {
  final Pelajaran? lesson;

  const CourseIntroductionTab(this.lesson, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengenalan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: primaryVeryDarkColor,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Pengantar materi ini',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            lesson == null
                ? const ShimmerCard(
                    height: 300,
                    width: double.infinity,
                    borderRadius: 0,
                  )
                : Text(
                    lesson!.pengenalanPelajaran, // Ensure non-null text
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Pokok Bahasan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: primaryVeryDarkColor,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Materi pelajaran utama',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            lesson != null
                ? const ShimmerCard(
                    height: 300, width: double.infinity, borderRadius: 0)
                : Text(
                    lesson!.pokokBahasanPelajaran,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }
}
