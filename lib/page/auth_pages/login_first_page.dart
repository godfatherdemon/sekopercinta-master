import 'package:flutter/material.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/utils/constants.dart';

class LoginFirstPage extends StatelessWidget {
  final ValueNotifier<int> _activeIndex;
  LoginFirstPage(this._activeIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/img-login-first.png',
                    height: 279,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Buka Sekoper Cinta Anda',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Daftarkan diri Anda untuk mengikuti program Sekoper Cinta. Masuk untuk mulai beraktivitas bersama kami.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              FillButton(
                text: 'Masuk',
                onTap: () {
                  _activeIndex.value = 3;
                },
                leading: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
