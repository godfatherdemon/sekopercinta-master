import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sekopercinta_master/providers/activities.dart';
import 'package:sekopercinta_master/providers/lessons.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class DocumentActivityPage extends HookWidget {
  final String id;
  final Aktivitas aktivitas;

  DocumentActivityPage({
    required this.id,
    required this.aktivitas,
  });
  @override
  Widget build(BuildContext context) {
    final _scrollController = useScrollController();
    final _progressReading = useState(0.0);
    final _isFinish = useState(false);
    final _data = useState<String?>(null);

    final _isLoading = useState(false);

    final _updateProgress = useMemoized(
        () => () async {
              _isLoading.value = true;

              var progress = _progressReading.value;

              if (progress == 0) {
                return true;
              }

              if (aktivitas.progresAktivitas.isNotEmpty) {
                if (aktivitas.progresAktivitas[0].progres > progress) {
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

    useEffect(() {
      _scrollController.addListener(() {
        if (_progressReading.value != 1) {
          if (_progressReading.value <
              _scrollController.position.pixels /
                  _scrollController.position.maxScrollExtent) {
            _progressReading.value = _scrollController.position.pixels /
                _scrollController.position.maxScrollExtent;
          }
        }

        _isFinish.value = _progressReading.value == 1;
      });
      return;
    }, []);
    return PopScope(
      onPopInvoked: (bool isPopGesture) async {
        await _updateProgress();
      },
      // onWillPop: () async {
      //   await _updateProgress();
      //   return true;
      // },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      color: brokenWhite,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: primaryBlack,
                            ),
                            onPressed: () async {
                              final result = await _updateProgress();
                              if (result != null && result) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.read(lessonProvider).namaPelajaran,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  aktivitas.namaAktivitas,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: 22,
                                      ),
                                ),
                                const SizedBox(
                                  height: 42,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic-essay.png',
                                      color: secondaryDarkColor,
                                      width: 16,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '${(aktivitas.sumberAktivitas[0].durasiKonten).toString().split(':')[1]} Min Read',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Markdown(
                      controller: _scrollController,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      selectable: true,
                      data: _data.value!,
                    ),
                  ),
                  Material(
                    elevation: 10,
                    color: Colors.white,
                    child: Ink(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            width: 36,
                            height: 36,
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color:
                                  _isFinish.value ? primaryBlue : primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      child: child, scale: animation);
                                },
                                child: _isFinish.value
                                    ? Image.asset(
                                        'assets/images/ic-done.png',
                                        key: ValueKey<int>(0),
                                        width: 22.5,
                                      )
                                    : Image.asset(
                                        'assets/images/ic-act.png',
                                        key: ValueKey<int>(1),
                                        width: 22.5,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sedang membaca',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: primaryBlack.withOpacity(0.5),
                                      ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Mengapa Sekoper Cinta',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: _progressReading.value,
                                    backgroundColor:
                                        accentColor.withOpacity(0.1),
                                    valueColor: _isFinish.value
                                        ? AlwaysStoppedAnimation<Color>(
                                            primaryBlue)
                                        : AlwaysStoppedAnimation<Color>(
                                            accentColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
