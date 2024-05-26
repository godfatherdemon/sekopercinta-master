import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/page/course_pages/course_page.dart';
import 'package:sekopercinta_master/page/course_pages/course_vocation_page.dart';
import 'package:sekopercinta_master/page/profile_pages/profile_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/social_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';

import '../home_page/home_page.dart';

class BottomNavPage extends HookWidget {
  static const routeName = '/tab-page';

  const BottomNavPage({super.key});
  // const BottomNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final onItemTapped = useMemoized(
      () => (int index) {
        selectedIndex.value = index;
      },
      [],
    );

    final List<Widget> pages = <Widget>[
      HomePage(selectedIndex),
      CourseVocationPage(selectedIndex),
      CoursePage(selectedIndex),
      SocialPage(selectedIndex),
      ProfilePage(selectedIndex),
    ];

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => onItemTapped(0),
                // onTap: () => selectedIndex.value,
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Beranda',
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            selectedIndex.value == 0
                                ? BlendMode.dst
                                : BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/ic-menu-home.png',
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Beranda',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selectedIndex.value == 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selectedIndex.value == 0
                                ? accentColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onItemTapped(1),
                // onTap: () => selectedIndex.value,
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Vokasi',
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            selectedIndex.value == 1
                                ? BlendMode.dst
                                : BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/ic-menu-vocation.png',
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Vokasi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selectedIndex.value == 1
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selectedIndex.value == 1
                                ? accentColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onItemTapped(2),
                // onTap: () => selectedIndex.value,
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Kelas',
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            selectedIndex.value == 2
                                ? BlendMode.dst
                                : BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/ic-menu-sekoci.png',
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Dasar',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selectedIndex.value == 2
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selectedIndex.value == 2
                                ? accentColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onItemTapped(3),
                // onTap: () => selectedIndex.value,
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Sosial',
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            selectedIndex.value == 3
                                ? BlendMode.dst
                                : BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/ic-menu-social.png',
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Sosial',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selectedIndex.value == 3
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selectedIndex.value == 3
                                ? accentColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onItemTapped(4),
                // onTap: () => selectedIndex.value,
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Profilku',
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            selectedIndex.value == 4
                                ? BlendMode.dst
                                : BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/ic-menu-profile.png',
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Profilku',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selectedIndex.value == 4
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selectedIndex.value == 4
                                ? accentColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            // children: [
            //   buildNavItem(0, 'Beranda', 'assets/images/ic-menu-home.png'),
            //   buildNavItem(1, 'Vokasi', 'assets/images/ic-menu-vocation.png'),
            //   buildNavItem(2, 'Dasar', 'assets/images/ic-menu-sekoci.png'),
            //   buildNavItem(3, 'Sosial', 'assets/images/ic-menu-social.png'),
            //   buildNavItem(4, 'Profilku', 'assets/images/ic-menu-profile.png'),
            // ],
          ),
        ),
      ),
      body: pages[selectedIndex.value],
    );
  }
}
