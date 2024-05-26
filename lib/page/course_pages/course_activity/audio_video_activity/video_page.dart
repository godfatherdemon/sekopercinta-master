import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class VideoPage extends HookWidget {
  final String id;
  final List<ProgresAktivita> progressAktivitas;

  const VideoPage({
    super.key,
    required this.id,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final data = useState<String?>(null);
    final isLoading = useState<bool>(false);

    useEffect(() {
      isLoading.value = true;
      context
          .read(activityProvider.notifier)
          .getActivityContent(context.read(hasuraClientProvider).state, id)
          .then((value) {
        data.value = value;
        isLoading.value = false;
      });
      return;
    }, []);

    return isLoading.value
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : FullScreenVideo(
            url: data.value!,
            id: id,
            progressAktivitas: progressAktivitas,
          );
  }
}
