import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta_master/providers/contributor.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class MentorPage extends HookWidget {
  const MentorPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: gradientA,
        ),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                pinned: false,
                expandedHeight: 190.0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Detail Master of Trainer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Text(
                          'Master of Trainer\nSekopercinta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sambutan Master of Trainer',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(createRoute(
                                      page: FullScreenVideo(
                                    url:
                                        'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/mastertrainer_mawarpohan.mp4',
                                    id: '',
                                    progressAktivitas: [],
                                  )));
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          'assets/images/img-mentor-tumbnail.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/images/ic-play.png',
                                              height: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Card(
                        color: Color(0xFFF4F7F9),
                        shadowColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Master of Trainer Sekopercinta',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: mentor.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 6,
                                  crossAxisSpacing: 12,
                                ),
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Image.asset(
                                      mentor[index].imagePath,
                                      width: 103,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      mentor[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/bg-card-2.png',
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
