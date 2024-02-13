import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:sekopercinta/components/custom_app_bar/pop_app_bar.dart';
// import 'package:sekopercinta/page/auth_pages/sign_up_setup_pages/setup_education_certificate_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_education_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_history_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_profile_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_resume_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/setup_user_data_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class SignUpSetupPage extends HookWidget {
  const SignUpSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageViewController = usePageController();
    final activePage = useState(0);
    final pages = useState([
      SetupUserDataPage(
        currentPage: activePage,
        pageController: pageViewController,
      ),
      // SetupFacilitatorPage(
      //   currentPage: _activePage,
      //   pageController: _pageViewController,
      // ),
      SetupEducationPage(
        currentPage: activePage,
        pageController: pageViewController,
      ),
      // SetupEducationCertificatePage(
      //   currentPage: _activePage,
      //   pageController: _pageViewController,
      // ),
      SetupHistoryPage(
        currentPage: activePage,
        pageController: pageViewController,
      ),
      SetupResumePage(
        currentPage: activePage,
        pageController: pageViewController,
      ),
      SetupProfilePage(
        currentPage: activePage,
        pageController: pageViewController,
      ),
    ]);
    return PopScope(
      onPopInvoked: (bool result) async {
        if (activePage.value == 0) {
          Navigator.of(context).pop(result);
        } else {
          activePage.value--;
          pageViewController.animateToPage(
            activePage.value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Buat Akun'),
                leading: IconButton(
                  onPressed: () {
                    if (activePage.value == 0) {
                      Navigator.of(context).pop(true);
                    } else {
                      activePage.value--;
                      pageViewController.animateToPage(
                        activePage.value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              // onPop: () {
              //   if (_activePage.value == 0) {
              //     Navigator.of(context).pop(true);
              //   } else {
              //     _activePage.value--;
              //     _pageViewController.animateToPage(
              //       _activePage.value,
              //       duration: Duration(milliseconds: 300),
              //       curve: Curves.ease,
              //     );
              //   }
              // },
              // ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    backgroundColor: accentColor.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(accentColor),
                    value: (activePage.value + 1) / pages.value.length,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageViewController,
                  children: pages.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return WillPopScope(
    //   onWillPop: () async {
    //     await Future.delayed(Duration.zero);
    //     if (_activePage.value == 0) {
    //       return true;
    //     }

    //     _activePage.value--;
    //     _pageViewController.animateToPage(
    //       _activePage.value,
    //       duration: Duration(milliseconds: 300),
    //       curve: Curves.ease,
    //     );
    //     return false;
    //   },
    //   child: Scaffold(
    //     backgroundColor: backgroundColor,
    //     body: SafeArea(
    //       child: Column(
    //         children: [
    //           PopAppBar(
    //             title: 'Buat Akun',
    //             isBackIcon: true,
    //             onPop: () {
    //               if (_activePage.value == 0) {
    //                 Navigator.of(context).pop();
    //               }

    //               _activePage.value--;
    //               _pageViewController.animateToPage(
    //                 _activePage.value,
    //                 duration: Duration(milliseconds: 300),
    //                 curve: Curves.ease,
    //               );
    //             },
    //           ),
    //           const SizedBox(
    //             height: 16,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(8),
    //               child: LinearProgressIndicator(
    //                 minHeight: 8,
    //                 backgroundColor: accentColor.withOpacity(0.1),
    //                 valueColor: AlwaysStoppedAnimation(accentColor),
    //                 value: (_activePage.value + 1) / _pages.value.length,
    //               ),
    //             ),
    //           ),
    //           Expanded(
    //             child: PageView(
    //               physics: NeverScrollableScrollPhysics(),
    //               controller: _pageViewController,
    //               children: _pages.value,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
