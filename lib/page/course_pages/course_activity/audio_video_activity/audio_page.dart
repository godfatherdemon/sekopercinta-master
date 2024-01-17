import 'dart:async';

// for File

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:sekopercinta/providers/activities.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sekopercinta/utils/hasura_config.dart'; // import this

class AudioPage extends HookWidget {
  final String id;
  final String title;
  final List<ProgresAktivita> progressAktivitas;

  AudioPage({
    required this.id,
    required this.title,
    required this.progressAktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final _audioPlayer = useState<AudioPlayer>(AudioPlayer());
    final _currentDuration = useState<Duration>(Duration.zero);
    final _totalDuration = useState(Duration.zero);
    final _durationSubscription = useState<StreamSubscription?>(null);
    final _positionSubscription = useState<StreamSubscription?>(null);

    final _isLoading = useState(false);
    final _isPlaying = useState(false);
    final _playPauseAnimation =
        useAnimationController(duration: Duration(milliseconds: 300));

    final _url = useState<String?>(null);

    final _updateProgress = useMemoized(
        () => () async {
              _isLoading.value = true;

              final currentPosition = _currentDuration.value.inSeconds;
              final totalDuration = _totalDuration.value.inSeconds;
              var progress = currentPosition / totalDuration;

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
      final getActivityAndPlay = () async {
        try {
          final value = await context
              .read(activityProvider.notifier)
              .getActivityContent(context.read(hasuraClientProvider).state, id);

          _url.value = value;
          // await play(); // Make sure to await play
        } catch (error) {
          // Handle the error if necessary
          print('Error: $error');
        }
      };

      // Immediately invoke the asynchronous function inside useEffect
      getActivityAndPlay();

      return () {
        if (_durationSubscription.value != null) {
          _durationSubscription.value?.cancel();
        }

        if (_positionSubscription.value != null) {
          _positionSubscription.value?.cancel();
        }
      };
    }, []); // Pass an empty dependency list to run the effect only once

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        onPopInvoked: (bool isPopGesture) async {
          await _audioPlayer.value.stop();
          await _updateProgress();
        },
        // onWillPop: () async {
        //   await _audioPlayer.value.stop();
        //   await _updateProgress();
        //   return true;
        // },
        child: Scaffold(
          backgroundColor: accentColor,
          body: _isLoading.value || _url.value == null
              ? Center(
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
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await _audioPlayer.value.stop();
                              var result = await _updateProgress();
                              if (result != null && result) {
                                Navigator.of(context).pop();
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
                                          '${(_currentDuration.value.toString().split('.').first).split(':')[1]}:${(_currentDuration.value.toString().split('.').first).split(':')[2]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          '${(_totalDuration.value.toString().split('.').first).split(':')[1]}:${(_totalDuration.value.toString().split('.').first).split(':')[2]}',
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
                                            AlwaysStoppedAnimation<Color>(
                                                primaryDarkColor),
                                        backgroundColor:
                                            primaryDarkColor.withOpacity(0.1),
                                        value: (_currentDuration
                                                    .value.inMilliseconds >
                                                0)
                                            ? _currentDuration
                                                    .value.inMilliseconds /
                                                _totalDuration
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
                                            await _audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds:
                                                        _currentDuration.value
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
                                                progress: _playPauseAnimation,
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
                                            if ((_currentDuration
                                                        .value.inMilliseconds +
                                                    10000) <
                                                _totalDuration
                                                    .value.inMilliseconds) {
                                              await _audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds:
                                                        _currentDuration.value
                                                                .inMilliseconds +
                                                            10000),
                                              );
                                            } else {
                                              await _audioPlayer.value.seek(
                                                Duration(
                                                    milliseconds: _totalDuration
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
