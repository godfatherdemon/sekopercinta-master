import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/communities_componenets/community_item.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/auth_pages/login_first_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/add_post_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/communities.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class SocialPage extends HookWidget {
  final ValueNotifier<int> _activeIndex;
  const SocialPage(this._activeIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final posts = useState<List<Komunitas>>(context.read(communitiesProvider));

    final isLoading = useState(false);

    final getCommunityPosts = useMemoized(
        () => () async {
              try {
                if (posts.value.isEmpty) {
                  isLoading.value = true;
                }

                await context.read(communitiesProvider.notifier).getCommunities(
                      context.read(hasuraClientProvider).state,
                    );
                // posts.value = context.read(communitiesProvider);
                posts.value = communitiesProvider as List<Komunitas>;
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }
              isLoading.value = false;
            },
        []);

    useEffect(() {
      if (context.read(authProvider.notifier).isAuth) {
        getCommunityPosts();
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                final result = await Navigator.of(context)
                    .push(createRoute(page: const AddPostPage()));

                if (result != null) {
                  if (result) {
                    getCommunityPosts();
                  }
                }
              },
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                    isLoading.value
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20.0),
                            itemCount: 5,
                            itemBuilder: (context, index) => const ShimmerCard(
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
                        : posts.value.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(20.0),
                                itemCount: posts.value.length,
                                itemBuilder: (context, index) =>
                                    CommunityItem(posts.value[index]),
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
