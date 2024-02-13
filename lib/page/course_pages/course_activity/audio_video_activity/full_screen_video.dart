import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:video_player/video_player.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenVideo extends HookWidget {
  final String url;
  final String id;
  final List<ProgresAktivita> progressAktivitas;

  FullScreenVideo({
    required this.url,
    required this.id,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final _videoPlayerController = useState<VideoPlayerController?>(null);
    final _chewieController = useState<ChewieController?>(null);

    final _isLoading = useState(false);

    final _updateProgress = useMemoized(
        () => () async {
              _isLoading.value = true;

              final currentPosition =
                  _videoPlayerController.value?.value.position.inSeconds;
              final totalDuration =
                  _videoPlayerController.value?.value.duration.inSeconds;
              var progress = currentPosition! / totalDuration!;

              if (progressAktivitas.isNotEmpty) {
                if (progressAktivitas[0].progres > progress) {
                  return;
                }
              }

              if (progress == 0) {
                return;
              }

              print(progress);
              print(id);
              try {
                await context.read(activityProvider.notifier).updateProgress(
                      context,
                      context.read(hasuraClientProvider).state,
                      id,
                      progress,
                    );

                Navigator.of(context).pop(true);
              } catch (error) {
                _isLoading.value = false;
                print('ERROR ${error.toString()}');
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
        _chewieController.value = chewieController;
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
        await _updateProgress();
      },

      child: Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: SafeArea(
          child: Center(
            child: _isLoading.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : _chewieController.value != null &&
                        _chewieController
                            .value!.videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController.value!,
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
          ),
        ),
      ),
    );
  }
}
