import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/resume_activity/resume_activity_page.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class FinishActivityPage extends StatelessWidget {
  final Aktivitas activity;
  final List<Pertanyaan> questions;
  final List<String> answers;

  FinishActivityPage({
    required this.activity,
    required this.questions,
    required this.answers,
  });
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: accentColor,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/images/anm-done.json',
                    ),
                    Text(
                      'Aktivitas telah selesai!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Anda berhasil menyelesaikan aktivitas ini, hebat\nAyo lihat hasilnya sekarang',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 24.0,
              ),
              child: FillButton(
                color: Colors.white,
                textColor: accentColor,
                text: 'Lanjutkan',
                onTap: () async {
                  await Navigator.of(context).pushReplacement(createRoute(
                      page: ResumeActivityPage(
                    activity: activity,
                    answer: answers,
                    question: questions,
                  )));
                },
                leading: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
