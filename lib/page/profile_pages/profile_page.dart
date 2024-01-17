import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sekopercinta/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta/page/auth_pages/login_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta/page/profile_pages/change_password_page.dart';
import 'package:sekopercinta/page/profile_pages/edit_profile_page.dart';
import 'package:sekopercinta/page/profile_pages/my_activity_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _isLoading = useState(false);
    final _userData = useState<UserData>(context.read(userDataProvider));

    final _imageKey = useState(DateTime.now().toString());

    final _getUserData = useMemoized(
        () => () async {
              if (context.read(authProvider.notifier).isAuth) {
                if (_userData.value.namaPengguna == null) {
                  _isLoading.value = true;
                }

                try {
                  await context.read(userDataProvider.notifier).getUserData(
                        context.read(hasuraClientProvider).state,
                      );
                  _userData.value = context.read(userDataProvider);
                } catch (error) {
                  _isLoading.value = false;
                  throw error;
                }
                _isLoading.value = false;
              }
            },
        []);

    useEffect(() {
      _getUserData();
      return;
    }, []);

    return !context.read(authProvider.notifier).isAuth
        ? LoginPage()
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
              physics: BouncingScrollPhysics(),
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
                        _isLoading.value
                            ? ShimmerCard(
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
                                            child: _userData.value.fotoProfil
                                                    .toString()
                                                    .contains('http')
                                                ? Image.network(
                                                    '${_userData.value.fotoProfil}?v=${_imageKey.value}',
                                                    fit: BoxFit.cover,
                                                    height: 60,
                                                    width: 60,
                                                  )
                                                : Image.asset(
                                                    _userData.value
                                                                .fotoProfil ==
                                                            '{{default_1}}'
                                                        ? 'assets/images/img-women-a.png'
                                                        : _userData.value
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
                                                  _userData
                                                          .value.namaPengguna ??
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
                                                  _userData.value.email,
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
                                      Divider(),
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
                                              if (_userData
                                                      .value.tanggalLahir !=
                                                  null)
                                                Text(
                                                  'Tgl. Lahir',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              if (_userData
                                                      .value.tanggalLahir !=
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
                                              if (_userData.value
                                                      .pendidikanTerakhir !=
                                                  null)
                                                Text(
                                                  'Pendidikan',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              if (_userData.value
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
                                                  _userData.value.nik,
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
                                                if (_userData
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
                                                    _userData.value
                                                                .tanggalLahir !=
                                                            null
                                                        ? DateFormat(
                                                                'dd MMMM yyyy')
                                                            .format(_userData
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
                                                if (_userData
                                                        .value.tanggalLahir !=
                                                    null)
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                // if (_userData.value
                                                //         .statusPernikahan !=
                                                //     null)
                                                Text(
                                                  _userData.value
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
                                                if (_userData.value
                                                        .pendidikanTerakhir !=
                                                    null)
                                                  Text(
                                                    _userData.value
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
                                                if (_userData.value
                                                        .pendidikanTerakhir !=
                                                    null)
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                // if (_userData.value.alamat !=
                                                //     null)
                                                Text(
                                                  _userData.value.alamat,
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
                        _isLoading.value
                            ? ShimmerCard(
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
                                                  page: MyActivityPage()));
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: Alignment(-1.2, 0),
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
                                          final isEdit =
                                              await Navigator.of(context).push(
                                                  createRoute(
                                                      page: EditProfilePage()));

                                          if (isEdit == null) {
                                            return;
                                          }

                                          _isLoading.value = true;
                                          _imageKey.value =
                                              DateTime.now().toString();
                                          _getUserData();
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: Alignment(-1.2, 0),
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
                                          Navigator.of(context).push(
                                              createRoute(
                                                  page: ChangePasswordPage()));
                                        },
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Align(
                                          alignment: Alignment(-1.2, 0),
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
                                                  page: BottomNavPage()),
                                              (route) => false);
                                        },
                                        title: Align(
                                          alignment: Alignment(-1.2, 0),
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
