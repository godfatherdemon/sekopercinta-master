import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:video_player/video_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenVideo extends HookWidget {
  final String url;
  final String id;
  final List<ProgresAktivita> progressAktivitas;

  const FullScreenVideo({
    super.key,
    required this.url,
    required this.id,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final videoPlayerController0 = useState<VideoPlayerController?>(null);
    final chewieController0 = useState<ChewieController?>(null);

    final isLoading = useState(false);

    final updateProgress = useMemoized(
        () => () async {
              final navigator = Navigator.of(context);
              isLoading.value = true;

              final currentPosition =
                  videoPlayerController0.value?.value.position.inSeconds;
              final totalDuration =
                  videoPlayerController0.value?.value.duration.inSeconds;
              var progress = currentPosition! / totalDuration!;

              if (progressAktivitas.isNotEmpty) {
                if (progressAktivitas[0].progres > progress) {
                  return;
                }
              }

              if (progress == 0) {
                return;
              }

              // print(progress);
              // print(id);
              final Logger logger = Logger();
              logger.d(progress);
              logger.d(id);
              try {
                await context.read(activityProvider.notifier).updateProgress(
                      context,
                      context.read(hasuraClientProvider).state,
                      id,
                      progress,
                    );

                // Navigator.of(context).pop(true);
                navigator.pop('update');
              } catch (error) {
                isLoading.value = false;
                // print('ERROR ${error.toString()}');
                // final Logger logger = Logger();
                logger.d('ERROR ${error.toString()}');
                return;
              }
            },
        []);

    useEffect(() {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
      );

      videoPlayerController.initialize().then((_) {
        chewieController0.value = chewieController;
      });

      return () {
        videoPlayerController.dispose();
        chewieController.dispose();
      };
    }, [url]);

    return PopScope(
      // onWillPop: () async {
      //   await _updateProgress();
      //         return true;
      // },
      onPopInvoked: (bool isPopGesture) async {
        await updateProgress();
      },

      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Center(
            child: isLoading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : chewieController0.value != null &&
                        chewieController0
                            .value!.videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: chewieController0.value!,
                      )
                    : const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
          ),
        ),
      ),
    );
  }
}
