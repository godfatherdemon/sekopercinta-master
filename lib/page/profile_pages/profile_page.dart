import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sekopercinta_master/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta_master/page/auth_pages/login_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/page/profile_pages/change_password_page.dart';
import 'package:sekopercinta_master/page/profile_pages/edit_profile_page.dart';
import 'package:sekopercinta_master/page/profile_pages/my_activity_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class ProfilePage extends HookWidget {
  const ProfilePage(ValueNotifier<int> selectedIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final userData = useState<UserData>(context.read(userDataProvider));

    final imageKey = useState(DateTime.now().toString());

    final getUserData = useMemoized(
        () => () async {
              // final isAuth = context.read(authProvider.notifier).isAuth;
              // final userDataValue = userData.value;

              // if (isAuth) {
              //   if (userDataValue.namaPengguna == null) {
              //     isLoading.value = true;
              //   }

              //   try {
              //     final hasuraClientState =
              //         context.read(hasuraClientProvider).state;
              //     await context
              //         .read(userDataProvider.notifier)
              //         .getUserData(hasuraClientState);
              //     // userData.value = context.read(userDataProvider);
              //     userData.value = userDataProvider as UserData;
              //   } catch (error) {
              //     isLoading.value = false;
              //     rethrow;
              //   }
              //   isLoading.value = false;
              // }

              if (context.read(authProvider.notifier).isAuth) {
                if (userData.value.namaPengguna == null) {
                  isLoading.value = true;
                }

                try {
                  await context.read(userDataProvider.notifier).getUserData(
                        context.read(hasuraClientProvider).state,
                      );
                  // userData.value = context.read(userDataProvider);
                  userData.value = userDataProvider as UserData;
                } catch (error) {
                  isLoading.value = false;
                  rethrow;
                }
                isLoading.value = false;
              }
            },
        []);

    useEffect(() {
      getUserData();
      return;
    }, []);

    return !context.read(authProvider.notifier).isAuth
        ? const LoginPage()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Profil Saya',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -127,
                      right: -95,
                      child: Image.asset(
                        'assets/images/bg-blur.png',
                        color: primaryColor,
                        width: 241,
                      ),
                    ),
                    Positioned(
                      left: -127,
                      bottom: -95,
                      child: Image.asset(
                        'assets/images/bg-blur.png',
                        color: secondaryColor,
                        width: 241,
                      ),
                    ),
                    Column(
                      children: [
                        isLoading.value
                            ? const ShimmerCard(
                                height: 308,
                                width: double.infinity,
                                borderRadius: 12,
                              )
                            : Card(
                                elevation: 8,
                                shadowColor: primaryColor.withOpacity(0.08),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: userData.value.fotoProfil
                                                    .toString()
                                                    .contains('http')
                                                ? Image.network(
                                                    '${userData.value.fotoProfil}?v=${imageKey.value}',
                                                    fit: BoxFit.cover,
                                                    height: 60,
                                                    width: 60,
                                                  )
                                                : Image.asset(
                                                    userData.value.fotoProfil ==
                                                            '{{default_1}}'
                                                        ? 'assets/images/img-women-a.png'
                                                        : userData.value
                                                                    .fotoProfil ==
                                                                '{{default_2}}'
                                                            ? 'assets/images/img-women-b.png'
                                                            : 'assets/images/img-women-c.png',
                                                    fit: BoxFit.cover,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userData.value.namaPengguna ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color:
                                                            primaryVeryDarkColor,
                                                      ),
                                                ),
                                                Text(
                                                  userData.value.email,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: gradientPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    'Sudah Tersertifikasi',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // if (_userData.value.nik != null)
                                              Text(
                                                'NIK',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              // if (_userData.value.nik != null)
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              if (userData.value.tanggalLahir !=
                                                  null)
                                                Text(
                                                  'Tgl. Lahir',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              if (userData.value.tanggalLahir !=
                                                  null)
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                              // if (_userData
                                              //         .value.statusPernikahan !=
                                              //     null)
                                              Text(
                                                'Status',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              // if (_userData
                                              //         .value.statusPernikahan !=
                                              //     null)
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              if (userData.value
                                                      .pendidikanTerakhir !=
                                                  null)
                                                Text(
                                                  'Pendidikan',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              if (userData.value
                                                      .pendidikanTerakhir !=
                                                  null)
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                              // if (_userData.value.alamat !=
                                              //     null)
                                              Text(
                                                'Alamat',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // if (_userData.value.nik != null)
                                                Text(
                                                  userData.value.nik,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color:
                                                              primaryVeryDarkColor),
                                                ),
                                                // if (_userData.value.nik != null)
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                if (userData
                                                        .value.tanggalLahir !=
                                                    null)
                                                  Text(
                                                    // DateFormat('dd MMMM yyyy')
                                                    //     .format(_userData.value
                                                    //         .tanggalLahir),
                                                    // maxLines: 1,
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
                                                    // style: Theme.of(context)
                                                    //     .textTheme
                                                    //     .titleSmall
                                                    //     ?.copyWith(
                                                    //         color:
                                                    //             primaryVeryDarkColor),
                                                    userData.value
                                                                .tanggalLahir !=
                                                            null
                                                        ? DateFormat(
                                                                'dd MMMM yyyy')
                                                            .format(userData
                                                                .value
                                                                .tanggalLahir!)
                                                        : 'No Date', // Provide a default value or handle the null case
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color:
                                                              primaryVeryDarkColor,
                                                        ),
                                                  ),
                                                if (userData
                                                        .value.tanggalLahir !=
                                                    null)
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                // if (_userData.value
                                                //         .statusPernikahan !=
                                                //     null)
                                                Text(
                                                  userData.value
                                                          .statusPernikahan
                                                      ? 'Sudah Kawin'
                                                      : 'Belum Kawin',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color:
                                                              primaryVeryDarkColor),
                                                ),
                                                // if (_userData.value
                                                //         .statusPernikahan !=
                                                //     null)
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                if (userData.value
                                                        .pendidikanTerakhir !=
                                                    null)
                                                  Text(
                                                    userData.value
                                                        .pendidikanTerakhir!
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                            color:
                                                                primaryVeryDarkColor),
                                                  ),
                                                if (userData.value
                                                        .pendidikanTerakhir !=
                                                    null)
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                // if (_userData.value.alamat !=
                                                //     null)
                                                Text(
                                                  userData.value.alamat,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color:
                                                              primaryVeryDarkColor),
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
                        const SizedBox(
                          height: 16,
                        ),
                        isLoading.value
                            ? const ShimmerCard(
                                height: 308,
                                width: double.infinity,
                                borderRadius: 12,
                              )
                            : Card(
                                elevation: 8,
                                shadowColor: primaryColor.withOpacity(0.08),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Menu Lainnya',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: primaryVeryDarkColor,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              createRoute(
                                                  page:
                                                      const MyActivityPage()));
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: const Alignment(-1.2, 0),
                                          child: Text(
                                            'Aktivitas Saya',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: primaryVeryDarkColor,
                                                ),
                                          ),
                                        ),
                                        leading: Image.asset(
                                          'assets/images/ic-games-outlined.png',
                                          width: 24,
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        onTap: () async {
                                          final isEdit = await Navigator.of(
                                                  context)
                                              .push(createRoute(
                                                  page:
                                                      const EditProfilePage()));

                                          if (isEdit == null) {
                                            return;
                                          }

                                          isLoading.value = true;
                                          imageKey.value =
                                              DateTime.now().toString();
                                          getUserData();
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: const Alignment(-1.2, 0),
                                          child: Text(
                                            'Edit Profil',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: primaryVeryDarkColor,
                                                ),
                                          ),
                                        ),
                                        leading: Image.asset(
                                          'assets/images/ic-edit.png',
                                          width: 24,
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(createRoute(
                                              page:
                                                  const ChangePasswordPage()));
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: const Alignment(-1.2, 0),
                                          child: Text(
                                            'Ganti Password',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: primaryVeryDarkColor,
                                                ),
                                          ),
                                        ),
                                        leading: Image.asset(
                                          'assets/images/ic-lock.png',
                                          width: 24,
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        onTap: () {
                                          context
                                              .read(authProvider.notifier)
                                              .logout();
                                          context
                                              .read(userDataProvider.notifier)
                                              .resetUserData();
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              createRoute(
                                                  page: const BottomNavPage()),
                                              (route) => false);
                                        },
                                        title: Align(
                                          alignment: const Alignment(-1.2, 0),
                                          child: Text(
                                            'Logout',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: secondaryDarkColor,
                                                ),
                                          ),
                                        ),
                                        leading: Image.asset(
                                          'assets/images/ic-logout.png',
                                          width: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
