import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/bordered_button.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_in_email_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoadingGoogleSignIn = useState(false);

    final googleSignIn = useMemoized(
      () => () async {
        isLoadingGoogleSignIn.value = true;

        try {
          await context.read(authProvider.notifier).googleSignIn();

          if (context.read(authProvider).isEmpty) {
            isLoadingGoogleSignIn.value = false;
            return;
          }

          await context.read(userDataProvider.notifier).getUserData(
                context.read(hasuraClientProvider).state,
              );

          isLoadingGoogleSignIn.value = false;

          if (context.read(userDataProvider).namaPengguna == null) {
            Navigator.pushReplacement(
                context, createRoute(page: SignUpSetupPage()));
          } else {
            Navigator.pushAndRemoveUntil(
                context, createRoute(page: BottomNavPage()), (route) => false);
          }
        } catch (error) {
          isLoadingGoogleSignIn.value = false;
          rethrow;
        }

        // Navigator.pushReplacement(
        //     context, createRoute(page: SignUpSetupPage()));
      },
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/img-womans.png',
                    width: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Masuk untuk mulai\nbelajar di Sekoper Cinta',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 24,
              ),
              isLoadingGoogleSignIn.value
                  ? const Center(child: CircularProgressIndicator())
                  : BorderedButton(
                      text: 'Masuk dengan Google',
                      leading: Image.asset(
                        'assets/images/ic-google.png',
                        width: 20,
                      ),
                      onTap: googleSignIn,
                    ),
              // const SizedBox(
              //   height: 16,
              // ),
              // BorderedButton(
              //   text: 'Masuk dengan Facebook',
              //   leading: Image.asset(
              //     'assets/images/ic-facebook.png',
              //     width: 20,
              //   ),
              //   onTap: () {},
              // ),
              const SizedBox(
                height: 16,
              ),
              BorderedButton(
                text: 'Masuk dengan email',
                color: accentColor,
                textColor: accentColor,
                onTap: () {
                  Navigator.of(context)
                      .push(createRoute(page: SignInEmailPage()));
                },
                leading: Container(),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Text(
                  'belum memiliki akun?',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: primaryDarkGrey,
                      ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FillButton(
                text: 'Daftar Sekarang',
                onTap: () {
                  Navigator.of(context).push(
                    createRoute(
                      page: SignUpPage(),
                    ),
                  );
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
