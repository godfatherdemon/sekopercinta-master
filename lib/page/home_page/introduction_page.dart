import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class IntroductionPage extends HookWidget {
  const IntroductionPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _doc = useState<PDFDocument?>(null);
    useEffect(() {
      PDFDocument.fromAsset('assets/images/sk-gubernur.pdf').then((value) {
        _doc.value = value;
      });

      return;
    }, []);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/img-logo-sekoci.png',
                  width: 87.72,
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(createRoute(
                        page: FullScreenVideo(
                      url:
                          'https://webgeocreate.s3.ap-southeast-1.amazonaws.com/sekoper-cinta/home-assets/sekopercinta.mp4',
                      id: '',
                      progressAktivitas: [],
                    )));
                  },
                  child: Container(
                    height: 189,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: gradientD,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/img-thumbnail-introduction.png',
                            ),
                          ),
                        ),
                        Center(
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Pengantar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: primaryVeryDarkColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Center(
                  child: Text(
                    'Sambutan Sekoper Cinta',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: primaryVeryDarkColor,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Memberdayakan diri sebagai Perempuan perlu melalui beragam perjalanan. Simak pengantar dari Ibu Atalia',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: primaryVeryDarkColor,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Image.asset('assets/images/img-intoduction.jpeg')),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child:
                        Image.asset('assets/images/img-surat-pengantar.png')),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Text(
                    'Surat Pengantar dari Menteri',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (_doc.value != null)
                  const SizedBox(
                    height: 38,
                  ),
                if (_doc.value != null)
                  Text(
                    'SK Gubernur Jawa Barat',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: primaryVeryDarkColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                if (_doc.value != null)
                  const SizedBox(
                    height: 12,
                  ),
                if (_doc.value != null)
                  SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: PDFViewer(
                      showPicker: false,
                      document: _doc.value!,
                    ),
                  ),
                const SizedBox(
                  height: 38,
                ),
                Text(
                  'IKRAR SEKOPER CINTA',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: primaryVeryDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '''KAMI, PESERTA SEKOLAH PEREMPUAN CAPAI IMPIAN DAN CITA CITA ( SEKOPER CINTA ) PROVINSI JAWA BARAT MENYATAKAN S I A P:

MENJADI PEREMPUAN BERPENGETAHUAN, BERDAYA, MANDIRI DAN BAHAGIA;
MENJAGA KEHARMONISAN DAN KEUTUHAN RUMAH TANGGA;

MEMBERIKAN KESEMPATAN SETINGGI-TINGGINYA KEPADA ANAK-ANAK UNTUK MELANJUTKAN PENDIDIKAN BERKARAKTER DAN BERAKHLAK MULIA;

TIDAK MENIKAHKAN ANAK-ANAK SEBELUM USIA 19 TAHUN;

MELINDUNGI KELUARGA DARI INDIKASI TINDAK PIDANA PERDAGANGAN ORANG;

MENDUKUNG PROGRAM CEGAH STUNTING DENGAN POLA ASUH, POLA MAKAN, DAN SANITASI TERBAIK BAGI KELUARGA;

MENYEBARLUASKAN INFORMASI DAN MEMBAGI ILMU SEKOPER CINTA KEPADA SEBANYAK-BANYAKNYA PEREMPUAN;
''',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(child: Image.asset('assets/images/img-pengantar-1.png')),
                // const SizedBox(
                //   height: 16,
                // ),
                // Text(
                //   'Lorem Ipsum',
                //   style: Theme.of(context).textTheme.subtitle1.copyWith(
                //         color: primaryVeryDarkColor,
                //         fontWeight: FontWeight.w600,
                //       ),
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
                // Text(
                //   'Surat Keterangan Mentri terkait pengadaan dan pelaksanaan Sekopercinta di Jawa Barat',
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
                const SizedBox(
                  height: 24,
                ),
                Center(child: Image.asset('assets/images/img-pengantar-2.png')),
                const SizedBox(
                  height: 16,
                ),
                // Text(
                //   'Lorem Ipsum',
                //   style: Theme.of(context).textTheme.subtitle1.copyWith(
                //         color: primaryVeryDarkColor,
                //         fontWeight: FontWeight.w600,
                //       ),
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
                // Text(
                //   'Surat Keterangan Mentri terkait pengadaan dan pelaksanaan Sekopercinta di Jawa Barat',
                //   style: Theme.of(context).textTheme.bodyText1,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
