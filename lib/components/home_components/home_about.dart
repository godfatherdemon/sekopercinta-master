import 'package:flutter/material.dart';
import 'package:sekopercinta_master/page/home_page/contributor_page.dart';
import 'package:sekopercinta_master/page/home_page/introduction_page.dart';
import 'package:sekopercinta_master/page/home_page/mentor_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class HomeAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final about = [
      {
        'image': 'assets/images/img-pengantar-2.png',
        'title': 'Surat Pengantar Modul dari Menteri',
        'description':
            'Surat Keterangan Menteri terkait pengadaan dan pelaksanaan Sekopercinta di Jawa Barat',
      },
      {
        'image': 'assets/images/img-trainer.jpeg',
        'title': 'Master of Trainer',
        'description':
            'Master of Trainer Sekopercinta yang membantu proses belajar Anda',
      },
      {
        'image': 'assets/images/ic-about3.png',
        'title': 'Kontributor',
        'description':
            'Ministry of Gender Equality and Family (MOGEF) Korea Selatan, dan partner lainnya.',
      },
    ];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // if (context.read(authProvider).isAuth)
        //   Positioned(
        //     top: -81,
        //     right: -87,
        //     child: Image.asset(
        //       'assets/images/bg-blur.png',
        //       color: primaryColor,
        //       width: 241,
        //     ),
        //   ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kenali Sekopercinta Lebih Dekat',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Lebih akrab, lebih baik, mulai dari sini',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                ],
              ),
            ),
            ListView.separated(
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.of(context).push(
                        createRoute(
                          page: IntroductionPage(
                            key: GlobalKey(),
                          ),
                        ),
                      );
                      break;
                    case 1:
                      Navigator.of(context).push(
                        createRoute(
                          page: MentorPage(
                            key: GlobalKey(),
                          ),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.of(context).push(
                        createRoute(
                          page: ContributorPage(
                            key: GlobalKey(),
                          ),
                        ),
                      );
                      break;
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 161,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 8,
                        shadowColor: primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            about[index]['image']!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        about[index]['title']!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        about[index]['description']!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
