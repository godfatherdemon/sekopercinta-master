import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/answer_many_resume.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/flipcard_resume.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/multiple_choiche_resume.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/essay_resume.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/upload_resume.dart';
import 'package:sekopercinta_master/providers/classes.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/providers/activities.dart';

class ResumeActivityPage extends HookWidget {
  final Aktivitas activity;
  final List<Pertanyaan> question;
  final List<String> answer;

  const ResumeActivityPage({
    super.key,
    required this.activity,
    required this.question,
    required this.answer,
  });
  @override
  Widget build(BuildContext context) {
    final resume = useState<String?>(null);
    final titleResume = useState<String?>(null);
    final pengantar = useState<String?>(null);

    useEffect(() {
      context
          .read(activityProvider.notifier)
          .getActivityResume(
              context.read(hasuraClientProvider).state, activity.idAktivitas)
          .then((value) {
        resume.value = value['isi_resume'];
        titleResume.value = value['judul_resume'];
        pengantar.value = value['pengantar_ke_lampiran'];
      });
      return;
    }, []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: resume.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Image.asset(
                        'assets/images/ic-games-outlined.png',
                        width: 24,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Resume',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        activity.namaAktivitas,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                      if (activity.jenisAktivitas == 'essay')
                        EssayResumeComponents(
                          answer: answer,
                          question: question,
                        ),
                      if (activity.jenisAktivitas == 'multichoice' ||
                          activity.jenisAktivitas == 'multimanychoice')
                        MultipleChoiceResume(
                          answer: answer,
                          question: question,
                        ),
                      if (activity.jenisAktivitas == 'upload')
                        UploadResumeComponents(
                          answer: answer,
                          question: question,
                        ),
                      if (activity.jenisAktivitas == 'answermany')
                        AnswerManyResumeComponents(
                          answer: answer,
                          question: question,
                        ),
                      if (activity.jenisAktivitas == 'truefalse')
                        FlipCardResumeComponents(
                          answer: answer,
                          question: question,
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Kesimpulan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        titleResume.value ?? activity.namaAktivitas,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        resume.value ?? 'Default Value',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (pengantar.value != null)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EEFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Langkah Selanjutnya',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: primaryVeryDarkColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${pengantar.value}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Center(
                                child: TextButton(
                                  // onPressed: context
                                  //     .read(changeTabIndexProvider)
                                  //     .state?,
                                  onPressed: () {
                                    final onPressedFunction = context
                                        .read(changeTabIndexProvider)
                                        .state;

                                    onPressedFunction();

                                    // Now, you can use Navigator.of() with the proper BuildContext
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return WidgetsApp.router(
                                          color: backgroundColor);
                                    }));
                                  },
                                  child: Text(
                                    'Lihat Dokumen',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: accentColor,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 40,
                      ),
                      FillButton(
                        text: 'Selesai',
                        onTap: () => Navigator.of(context).pop(),
                        leading: Container(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
