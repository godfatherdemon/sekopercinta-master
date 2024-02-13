import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnBoardingSignUpPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _signUpData = ModalRoute.of(context)?.settings.arguments;
    final _isLoading = useState(false);

    final _submit = useMemoized(
      () => () async {
        _isLoading.value = true;

        // try {
        //   await context.read(authProvider.notifier).login(
        //         _signUpData,
        //         context.read(hasuraClientProvider).state,
        //       );
        // } catch (error) {
        //   _isLoading.value = false;
        //   throw error;
        // }

        try {
          // Ensure _signUpData is a Map<String, String>
          if (_signUpData is Map<String, String>) {
            await context.read(authProvider.notifier).login(
                  _signUpData,
                  context.read(hasuraClientProvider).state,
                );
          } else {
            // Handle the case where _signUpData is not a Map<String, String>
            throw ArgumentError('Invalid type for _signUpData');
          }
        } catch (error) {
          _isLoading.value = false;
          throw error;
        }

        Navigator.pushReplacement(
            context, createRoute(page: SignUpSetupPage()));
      },
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            PopAppBar(
              title: 'Buat Akun',
              justTitle: true,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child:
                        Image.asset('assets/images/img-onboarding-signup.png'),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Buat profil Anda',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Profil ini akan digunakan untuk mencatat proses perkembangan Anda bersama Sekoper Cinta!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : FillButton(
                      text: 'Lanjutkan',
                      onTap: _submit,
                      leading: Container(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
