import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/page/course_pages/course_page.dart';
import 'package:sekopercinta/page/course_pages/course_vocation_page.dart';
import 'package:sekopercinta/page/profile_pages/profile_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/social_page.dart';
import 'package:sekopercinta/utils/constants.dart';

import '../home_page/home_page.dart';

class BottomNavPage extends HookWidget {
  static const routeName = '/tab-page';

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = useState(0);

    final _onItemTapped = useMemoized(
      () => (int index) {
        _selectedIndex.value = index;
      },
      [],
    );

    final List<Widget> _pages = <Widget>[
      HomePage(_selectedIndex),
      CourseVocationPage(_selectedIndex),
      CoursePage(_selectedIndex),
      SocialPage(_selectedIndex),
      ProfilePage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => _onItemTapped(0),
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Beranda',
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            _selectedIndex.value == 0
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
                            fontWeight: _selectedIndex.value == 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedIndex.value == 0
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
                onTap: () => _onItemTapped(1),
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Vokasi',
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            _selectedIndex.value == 1
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
                            fontWeight: _selectedIndex.value == 1
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedIndex.value == 1
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
                onTap: () => _onItemTapped(2),
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Kelas',
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            _selectedIndex.value == 2
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
                            fontWeight: _selectedIndex.value == 2
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedIndex.value == 2
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
                onTap: () => _onItemTapped(3),
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Sosial',
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            _selectedIndex.value == 3
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
                            fontWeight: _selectedIndex.value == 3
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedIndex.value == 3
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
                onTap: () => _onItemTapped(4),
                borderRadius: BorderRadius.circular(30),
                child: Tooltip(
                  message: 'Profilku',
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey,
                            _selectedIndex.value == 4
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
                            fontWeight: _selectedIndex.value == 4
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: _selectedIndex.value == 4
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
          ),
        ),
      ),
      body: _pages[_selectedIndex.value],
    );
  }
}
