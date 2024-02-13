import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sekopercinta_master/page/course_pages/course_activity/audio_video_activity/full_screen_video.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class VideoPage extends HookWidget {
  final String id;
  final List<ProgresAktivita> progressAktivitas;

  VideoPage({
    required this.id,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final _data = useState<String?>(null);
    final _isLoading = useState<bool>(false);

    useEffect(() {
      _isLoading.value = true;
      context
          .read(activityProvider.notifier)
          .getActivityContent(context.read(hasuraClientProvider).state, id)
          .then((value) {
        _data.value = value;
        _isLoading.value = false;
      });
      return;
    }, []);

    return _isLoading.value
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : FullScreenVideo(
            url: _data.value!,
            id: id,
            progressAktivitas: progressAktivitas,
          );
  }
}
