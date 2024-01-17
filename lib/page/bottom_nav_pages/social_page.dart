import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/communities_componenets/community_item.dart';
import 'package:sekopercinta/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta/page/auth_pages/login_first_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/add_post_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/providers/communities.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class SocialPage extends HookWidget {
  final ValueNotifier<int> _activeIndex;
  SocialPage(this._activeIndex);

  @override
  Widget build(BuildContext context) {
    final _posts = useState<List<Komunitas>>(context.read(communitiesProvider));

    final _isLoading = useState(false);

    final _getCommunityPosts = useMemoized(
        () => () async {
              try {
                if (_posts.value.isEmpty) {
                  _isLoading.value = true;
                }

                await context.read(communitiesProvider.notifier).getCommunities(
                      context.read(hasuraClientProvider).state,
                    );
                _posts.value = context.read(communitiesProvider);
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

    return !context.read(authProvider.notifier).isAuth
        ? LoginFirstPage(_activeIndex)
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Komunitas',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                final result = await Navigator.of(context)
                    .push(createRoute(page: AddPostPage()));

                if (result != null) {
                  if (result) {
                    _getCommunityPosts();
                  }
                }
              },
            ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/ic-empty-discussion.png',
                                          width: 112,
                                        ),
                                        const SizedBox(
                                          height: 21,
                                        ),
                                        Text(
                                          'Komunitas Anda',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Temukan hasil karya Anda dan peseta lainnya pada halaman Komunitas ini.',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
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
