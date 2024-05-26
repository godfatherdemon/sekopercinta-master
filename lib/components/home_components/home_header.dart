import 'package:flutter/material.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 375.0,
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/img-logo-sekoci.png',
            width: 87.72,
          ),
          // Image.asset(
          //   'assets/images/ic-notif.png',
          //   width: 24,
          // ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(88),
                bottomRight: Radius.circular(88),
              ),
              child: Image.asset(
                'assets/images/vid-home-header2.webp',
                fit: BoxFit.fitHeight,
                height: 375,
              ),
            ),
            Container(
              width: double.infinity,
              height: 375,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(88),
                  bottomRight: Radius.circular(88),
                ),
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox.shrink(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(createRoute(
                              page: const FullScreenVideo(
                            url:
                                'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/pengantar_sekoci_app.mp4',
                            id: '',
                            progressAktivitas: [],
                          )));
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic-play.png',
                              height: 32,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Pengantar',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Sambutan Sekoper Cinta',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Memberdayakan diri sebagai Perempuan perlu melalui beragam perjalanan. Simak pengantar dari Ibu Atalia',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
