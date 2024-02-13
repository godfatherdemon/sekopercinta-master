import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/communities_componenets/detail_image.dart';
import 'package:sekopercinta_master/components/custom_shape/triangle_painter.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/providers/communities.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/string_extension.dart';

class CommunityItem extends HookWidget {
  final Komunitas post;

  CommunityItem(this.post);

  String formatDuration(Duration duration) {
    if (duration.inDays >= 30) {
      return '${(duration.inDays / 30).toStringAsFixed(0)} bulan yang lalu';
    } else if (duration.inDays >= 7) {
      return '${(duration.inDays / 7).toStringAsFixed(0)} minggu yang lalu';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} hari yang lalu';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} jam yang lalu';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} menit yang lalu';
    } else {
      return '${duration.inSeconds} detik yang lalu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isShowLikePopUp = useState(false);
    final _animationController =
        useAnimationController(duration: Duration(milliseconds: 400));

    final _iconAnimationController =
        useAnimationController(duration: Duration(milliseconds: 1000));

    // final _likeStatus = useState<String>(post.responsKomunitas.isEmpty
    //     ? null
    //     : post.responsKomunitas[0].respons);

    final _likeStatus = useState<String>(
      post.responsKomunitas.isEmpty
          ? "default_value"
          : post.responsKomunitas[0].respons,
    );

    final _isLoading = useState(false);

    final _sendLikeResponse = useMemoized(
        () => (String response) async {
              try {
                _isLoading.value = true;

                await context.read(communitiesProvider.notifier).giveResponse(
                      likeResponse: response,
                      id: post.idKiriman,
                      hasuraConnect: context.read(hasuraClientProvider).state,
                      // isUpdate: _likeStatus.value != null,
                      isUpdate: _likeStatus.value.isNotEmpty,
                    );
                _likeStatus.value = response;
                post.funnyCount++;

                _iconAnimationController.forward();
                Future.delayed(Duration(seconds: 1)).then(
                    (value) => _iconAnimationController.reverse(from: 0.5));
              } catch (error) {
                _isLoading.value = false;

                throw error;
              }

              _isLoading.value = false;
            },
        []);

    return Stack(
      children: [
        Card(
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: post.profilPublik.fotoProfil
                              .toString()
                              .contains('http')
                          ? Image.network(
                              '${post.profilPublik.fotoProfil}',
                              fit: BoxFit.cover,
                              height: 36,
                              width: 36,
                            )
                          : Image.asset(
                              post.profilPublik.fotoProfil == '{{default_1}}'
                                  ? 'assets/images/img-women-a.png'
                                  : post.profilPublik.fotoProfil ==
                                          '{{default_2}}'
                                      ? 'assets/images/img-women-b.png'
                                      : 'assets/images/img-women-c.png',
                              fit: BoxFit.cover,
                              height: 36,
                              width: 36,
                            ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // post.profilPublik.namaPengguna ?? 'Unknown',
                            post.profilPublik.namaPengguna,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Text(
                            '${formatDuration(DateTime.now().difference(post.dikirimPada))}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  post.komentar,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => DetailImage(post),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 202,
                      foregroundDecoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            post.foto,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ShimmerCard(
                        height: 202,
                        width: double.infinity,
                        borderRadius: 6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!_isShowLikePopUp.value) {
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                        }
                        _isShowLikePopUp.value = !_isShowLikePopUp.value;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // Image.asset(
                            //   _likeStatus.value == null
                            //       ? 'assets/images/ic-like-placeholder.png'
                            //       : 'assets/images/ic-${_likeStatus.value}.png',
                            //   width: 18,
                            // ),
                            Image.asset(
                              'assets/images/ic-${_likeStatus.value}.png',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            // Text(
                            //   _likeStatus.value == null
                            //       ? 'Suka'
                            //       : _likeStatus.value.capitalizeFirstOfEach,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyLarge
                            //       ?.copyWith(
                            //         color: _likeStatus.value == null
                            //             ? Color(0xFF7F8C8D)
                            //             : Color(0xFF217CE8),
                            //         fontWeight: _likeStatus.value != null
                            //             ? FontWeight.bold
                            //             : FontWeight.w400,
                            //       ),
                            // ),
                            Text(
                              _likeStatus.value.capitalizeFirstOfEach,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Color(0xFF217CE8),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/ic-like.png',
                            width: 12,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            'assets/images/ic-super.png',
                            width: 12,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            'assets/images/ic-wow.png',
                            width: 12,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          // Text(
                          //   ((post.funnyCount +
                          //                   post.likeCount +
                          //                   post.superCount +
                          //                   post.wowCount) >
                          //               1 &&
                          //           _likeStatus.value != null)
                          //       ? 'Anda dan ${post.funnyCount + post.likeCount + post.superCount + post.wowCount - 1} Lainnya'
                          //       : (_likeStatus.value != null &&
                          //               (post.funnyCount +
                          //                       post.likeCount +
                          //                       post.superCount +
                          //                       post.wowCount) ==
                          //                   0)
                          //           ? '${post.funnyCount + post.likeCount + post.superCount + post.wowCount + 1}'
                          //           : '${post.funnyCount + post.likeCount + post.superCount + post.wowCount}',
                          //   style:
                          //       Theme.of(context).textTheme.bodyLarge?.copyWith(
                          //             color: Color(0xFF7F8C8D),
                          //           ),
                          // ),
                          Text(
                            ((post.funnyCount +
                                        post.likeCount +
                                        post.superCount +
                                        post.wowCount) >
                                    1)
                                ? 'Anda dan ${post.funnyCount + post.likeCount + post.superCount + post.wowCount - 1} Lainnya'
                                : ((post.funnyCount +
                                            post.likeCount +
                                            post.superCount +
                                            post.wowCount) ==
                                        0)
                                    ? '${post.funnyCount + post.likeCount + post.superCount + post.wowCount + 1}'
                                    : '${post.funnyCount + post.likeCount + post.superCount + post.wowCount}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Color(0xFF7F8C8D),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 56,
          left: 14,
          child: Container(
            height: 75,
            width: 300,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ScaleTransition(
                alignment: Alignment.bottomLeft,
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0,
                    0.5,
                    curve: Curves.ease,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 62,
                      width: 219.45,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E7EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.5,
                                0.625,
                                curve: Curves.ease,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _sendLikeResponse('like');
                                _isShowLikePopUp.value = false;
                                _animationController.reverse();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic-like.png',
                                    width: 22.68,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.625,
                                0.75,
                                curve: Curves.ease,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('super');
                                _sendLikeResponse('super');
                                _isShowLikePopUp.value = false;
                                _animationController.reverse();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic-super.png',
                                    width: 22.68,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.75,
                                0.875,
                                curve: Curves.ease,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _sendLikeResponse('wow');
                                _isShowLikePopUp.value = false;
                                _animationController.reverse();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic-wow.png',
                                    width: 22.68,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                0.875,
                                1,
                                curve: Curves.ease,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('funny');
                                _sendLikeResponse('funny');

                                _isShowLikePopUp.value = false;
                                _animationController.reverse();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic-funny.png',
                                    width: 22.68,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 27.0),
                      child: RotatedBox(
                        quarterTurns: 90,
                        child: CustomPaint(
                          painter: TrianglePainter(
                            strokeColor: Color(0xFFE3E7EA),
                            strokeWidth: 10,
                            paintingStyle: PaintingStyle.fill,
                          ),
                          child: Container(
                            height: 13,
                            width: 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading.value)
          Positioned.fill(
            child: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        Positioned.fill(
          child: Container(
            child: Center(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _iconAnimationController,
                  curve: Curves.elasticOut,
                ),
                // child: Image.asset(
                //   _likeStatus.value == null
                //       ? 'assets/images/ic-like-placeholder.png'
                //       : 'assets/images/ic-${_likeStatus.value}.png',
                //   width: 100,
                // ),
                child: Image.asset(
                  'assets/images/ic-${_likeStatus.value}.png',
                  width: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
