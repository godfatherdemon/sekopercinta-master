import 'package:flutter/material.dart';
import 'package:sekopercinta/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class HomeInspiration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inspiration = [
      {
        'image': 'assets/images/ic-inspiration1.jpg',
        'title': 'Ibu Ika - Kab Kuningan',
        'description':
            'Dari prorgam Sekoper Cinta kami telah menghasilkan buku berjudul "Ibu Berdaya Keluarga Sejahtera"',
        'link':
            'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/Ibu+Ika+-+Kab+Kuningan.mp4'
      },
      {
        'image': 'assets/images/ic-inspiration2.jpg',
        'title': 'Ibu Nurliasari - Kab Bandung Barat',
        'description':
            'Program Sekoper Cinta menambah wawasan saya menyiapkan diri dan keluarga dalam menghadapi bencana',
        'link':
            'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/Ibu+Nurliasari+-+Kab+Bandung+Barat.mp4'
      },
      {
        'image': 'assets/images/ic-inspiration3.jpg',
        'title': 'Ibu Nurhayati - Kota Cirebon',
        'description': 'Ibu Nurhayati - Kota Cirebon',
        'link':
            'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/Ibu+Nurhayati+-+Kab+Cirebon.mp4'
      },
      {
        'image': 'assets/images/ic-inspiration4.jpg',
        'title': 'Ibu Neni - Kab Purwakarta',
        'description':
            'Sekoper Cinta mengajarkan kami pengelolaan keuangan keluarga, seperti pengeluaran sekunder dan primer',
        'link':
            'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/Ibu+Neni+-+Kab+Purwakarta.mp4'
      },
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -42,
          left: -97,
          child: Image.asset(
            'assets/images/bg-blur.png',
            color: secondaryColor,
            width: 191,
          ),
        ),
        Column(
          children: [
            Text(
              'Berbagi Inspirasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Simak cerita sukses para alumni Sekopercinta dari berbagai penjuru Jawa Barat',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 161 / 238,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(createRoute(
                      page: FullScreenVideo(
                    url: inspiration[index]['link']!,
                    id: '',
                    progressAktivitas: [],
                  )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        inspiration[index]['image']!,
                        height: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      inspiration[index]['title']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      inspiration[index]['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ],
    );
  }
}
