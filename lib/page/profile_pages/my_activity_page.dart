import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/communities_componenets/community_item.dart';
import 'package:sekopercinta/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/providers/communities.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';

class MyActivityPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _posts = useState<List<Komunitas>>(context.read(myCommunityProvider));

    final _isLoading = useState(false);

    final _getCommunityPosts = useMemoized(
        () => () async {
              try {
                if (_posts.value.isEmpty) {
                  _isLoading.value = true;
                }

                await context
                    .read(myCommunityProvider.notifier)
                    .getMyCommunities(
                      context.read(hasuraClientProvider).state,
                    );
                _posts.value = context.read(myCommunityProvider);
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
              _isLoading.value = false;
            },
        []);

    useEffect(() {
      if (context.read(authProvider.notifier).isAuth) {
        _getCommunityPosts();
      }
      return;
    }, []);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Aktivitas Saya',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: primaryBlack,
          ),
        ),
      ),
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     showModalBottomSheet(
      //       context: context,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topRight: Radius.circular(12),
      //           topLeft: Radius.circular(12),
      //         ),
      //       ),
      //       builder: (context) => Padding(
      //         padding: const EdgeInsets.all(12.0),
      //         child: FilterMyActivityBottomSheet(),
      //       ),
      //     );
      //   },
      //   borderRadius: BorderRadius.circular(10),
      //   child: Ink(
      //     width: 92,
      //     height: 40,
      //     decoration: BoxDecoration(
      //       gradient: gradientPrimary,
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(
      //           Icons.filter_alt,
      //           color: Colors.white,
      //           size: 16,
      //         ),
      //         const SizedBox(
      //           width: 8,
      //         ),
      //         Text(
      //           'Filter',
      //           style: Theme.of(context).textTheme.subtitle2.copyWith(
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -127,
                left: -95,
                child: Image.asset(
                  'assets/images/bg-blur.png',
                  color: primaryColor,
                  width: 241,
                ),
              ),
              _isLoading.value
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20.0),
                      itemCount: 5,
                      itemBuilder: (context, index) => ShimmerCard(
                        height: 407,
                        width: double.infinity,
                        borderRadius: 10,
                      ),
                      separatorBuilder: (context, index) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (index % 2 == 0)
                            Positioned(
                              top: -50,
                              right: -86,
                              child: Image.asset(
                                'assets/images/bg-blur.png',
                                color: secondaryColor,
                                width: 191,
                              ),
                            ),
                          if (index % 2 == 1)
                            Positioned(
                              top: -50,
                              left: -86,
                              child: Image.asset(
                                'assets/images/bg-blur.png',
                                color: secondaryColor,
                                width: 191,
                              ),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )
                  : _posts.value.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20.0),
                          itemCount: _posts.value.length,
                          itemBuilder: (context, index) =>
                              CommunityItem(_posts.value[index]),
                          separatorBuilder: (context, index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (index % 2 == 0)
                                Positioned(
                                  top: -50,
                                  right: -86,
                                  child: Image.asset(
                                    'assets/images/bg-blur.png',
                                    color: secondaryColor,
                                    width: 191,
                                  ),
                                ),
                              if (index % 2 == 1)
                                Positioned(
                                  top: -50,
                                  left: -86,
                                  child: Image.asset(
                                    'assets/images/bg-blur.png',
                                    color: secondaryColor,
                                    width: 191,
                                  ),
                                ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 70,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/ic-empty-discussion.png',
                                    width: 112,
                                  ),
                                  const SizedBox(
                                    height: 21,
                                  ),
                                  Text(
                                    'Aktivitas Anda',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Temukan hasil karya yang telah selesai dari aktivitas Anda pada halaman ini.',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
