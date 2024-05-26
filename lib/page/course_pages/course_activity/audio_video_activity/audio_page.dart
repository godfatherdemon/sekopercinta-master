import 'dart:async';

// for File

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sekopercinta_master/utils/hasura_config.dart'; // import this

class AudioPage extends HookWidget {
  final String id;
  final String title;
  final List<ProgresAktivita> progressAktivitas;

  const AudioPage({
    super.key,
    required this.id,
    required this.title,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final audioPlayer = useState<AudioPlayer>(AudioPlayer());
    final currentDuration = useState<Duration>(Duration.zero);
    final totalDuration = useState(Duration.zero);
    final durationSubscription = useState<StreamSubscription?>(null);
    final positionSubscription = useState<StreamSubscription?>(null);

    final isLoading = useState(false);
    final isPlaying = useState(false);
    final playPauseAnimation =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final url = useState<String?>(null);

    final updateProgress = useMemoized(
        () => () async {
              final navigator = Navigator.of(context);
              isLoading.value = true;

              final currentPosition = currentDuration.value.inSeconds;
              final totalDurations = totalDuration.value.inSeconds;
              var progress = currentPosition / totalDurations;

              if (totalDuration == 0) {
                return true;
              }

              if (progress == 0) {
                return true;
              }

              if (progressAktivitas.isNotEmpty) {
                if (progressAktivitas[0].progres > progress) {
                  return true;
                }
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
                logger.d('ERROR ${error.toString()}');
                return true;
              }
            },
        []);

    // useEffect(() {
    //   context
    //       .read(activityProvider.notifier)
    //       .getActivityContent(context.read(hasuraClientProvider).state, id)
    //       .then((value) {
    //     _url.value = value;

    //     play();
    //   });
    //   return () {
    //     if (_durationSubscription.value != null) {
    //       _durationSubscription.value?.cancel();
    //     }

    //     if (_positionSubscription.value != null) {
    //       _positionSubscription.value?.cancel();
    //     }
    //   };
    // }, []);

    // Future<void> play() async {
    //   if (_url.value != null) {
    //     _isLoading.value = true;
    //     int result = await _audioPlayer.value.play(_url.value!);

    //     if (result == 1) {
    //       // success
    //       _isPlaying.value = true;
    //       _isLoading.value = false;

    //       _positionSubscription.value =
    //           _audioPlayer.value.onPositionChanged.listen((Duration p) {
    //         _currentDuration.value = p;
    //       });

    //       _durationSubscription.value =
    //           _audioPlayer.value.onDurationChanged.listen((Duration d) {
    //         _totalDuration.value = d;
    //       });
    //     }
    //   }
    // }

    useEffect(() {
      getActivityAndPlay() async {
        try {
          final value = await context
              .read(activityProvider.notifier)
              .getActivityContent(context.read(hasuraClientProvider).state, id);

          url.value = value;
          // await play(); // Make sure to await play
        } catch (error) {
          // Handle the error if necessary
          // print('Error: $error');
          final Logger logger = Logger();
          logger.d('Error: $error');
        }
      }

      // Immediately invoke the asynchronous function inside useEffect
      getActivityAndPlay();

      return () {
        if (durationSubscription.value != null) {
          durationSubscription.value?.cancel();
        }

        if (positionSubscription.value != null) {
          positionSubscription.value?.cancel();
        }
      };
    }, []); // Pass an empty dependency list to run the effect only once

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        onPopInvoked: (bool isPopGesture) async {
          await audioPlayer.value.stop();
          await updateProgress();
        },
        // onWillPop: () async {
        //   await _audioPlayer.value.stop();
        //   await _updateProgress();
        //   return true;
        // },
        child: Scaffold(
          backgroundColor: accentColor,
          body: isLoading.value || url.value == null
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await audioPlayer.value.stop();
                              var result = await updateProgress();
                              if (result != null && result) {
                                // Navigator.of(context).pop();
                                navigator.pop('stop');
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: Lottie.asset(
                            'assets/images/anm-audio.json',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${(currentDuration.value.toString().split('.').first).split(':')[1]}:${(currentDuration.value.toString().split('.').first).split(':')[2]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          '${(totalDuration.value.toString().split('.').first).split(':')[1]}:${(totalDuration.value.toString().split('.').first).split(':')[2]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        minHeight: 8,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                primaryDarkColor),
                                        backgroundColor:
                                            primaryDarkColor.withOpacity(0.1),
                                        value: (currentDuration
                                                    .value.inMilliseconds >
                                                0)
                                            ? currentDuration
                                                    .value.inMilliseconds /
                                                totalDuration
                                                    .value.inMilliseconds
                                            : 0.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Image.asset(
                                            'assets/images/ic-seek-backward.png',
                                            width: 24,
                                          ),
                                          onTap: () async {
                                            await audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds: currentDuration
                                                            .value
                                                            .inMilliseconds -
                                                        10000));
                                          },
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            // if (_isPlaying.value) {
                                            //   int result = await _audioPlayer
                                            //       .value
                                            //       .pause();
                                            //   if (result == 1) {
                                            //     _isPlaying.value = false;
                                            //     _playPauseAnimation.forward();
                                            //   }
                                            // } else {
                                            //   int result = await _audioPlayer
                                            //       .value
                                            //       .resume();
                                            //   if (result == 1) {
                                            //     _isPlaying.value = true;
                                            //     _playPauseAnimation.reverse();
                                            //   }
                                            // }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Ink(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: AnimatedIcon(
                                                icon: AnimatedIcons.pause_play,
                                                progress: playPauseAnimation,
                                                color: Colors.white,
                                                semanticLabel: 'Show menu',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                          child: Image.asset(
                                            'assets/images/ic-seek-forward.png',
                                            width: 24,
                                          ),
                                          onTap: () async {
                                            if ((currentDuration
                                                        .value.inMilliseconds +
                                                    10000) <
                                                totalDuration
                                                    .value.inMilliseconds) {
                                              await audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds: currentDuration
                                                            .value
                                                            .inMilliseconds +
                                                        10000),
                                              );
                                            } else {
                                              await audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds: totalDuration
                                                        .value.inMilliseconds),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
