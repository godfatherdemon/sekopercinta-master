import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:sekopercinta/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class SetupFinishPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(Duration(seconds: 5)).then((value) {
        Navigator.pushAndRemoveUntil(
            context, createRoute(page: BottomNavPage()), (route) => false);
      });
      return;
    }, []);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: accentColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/anm-loading.json',
                height: 120,
                width: 120,
              ),
              Text(
                'Mempersiapkan Akun...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Harap menunggu sejenak,\nkami sedang mempersiapkan akun anda',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
