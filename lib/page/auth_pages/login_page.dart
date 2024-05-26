import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sekopercinta_master/components/custom_button/bordered_button.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_in_email_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_in_email_page2.dart';
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
  // const LoginPage({super.key});
  const LoginPage({Key? key}) : super(key: key);

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(
      createRoute(
        page: const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingSignIn = useState(false);

    // final googleSignIn = useMemoized(
    //   () => () async {
    //     isLoadingGoogleSignIn.value = true;

    //     try {
    //       await context.read(authProvider.notifier).googleSignIn();

    //       if (context.read(authProvider).isEmpty) {
    //         isLoadingGoogleSignIn.value = false;
    //         return;
    //       }

    //       await context.read(userDataProvider.notifier).getUserData(
    //             context.read(hasuraClientProvider).state,
    //           );

    //       isLoadingGoogleSignIn.value = false;

    //       if (context.read(userDataProvider).namaPengguna == null) {
    //         Navigator.pushReplacement(
    //             context, createRoute(page: const SignUpSetupPage()));
    //       } else {
    //         Navigator.pushAndRemoveUntil(
    //             context, createRoute(page: BottomNavPage()), (route) => false);
    //       }
    //     } catch (error) {
    //       isLoadingGoogleSignIn.value = false;
    //       rethrow;
    //     }

    //     // Navigator.pushReplacement(
    //     //     context, createRoute(page: SignUpSetupPage()));
    //   },
    // );

    Future<void> login(
        Map<String, String> authData, HasuraConnect hasuraConnect) async {
      final Logger logger = Logger();

      // Construct the GraphQL query with variables for email and password
      const docQuery = r'''
    mutation Login($email: String!, $password: String!) {
      login(email: $email, password: $password) {
        accessToken
      }
    }
  ''';

      // Define variables for the query
      final variables = {
        'email': authData['email'],
        'password': authData['password'],
      };

      try {
        isLoadingSignIn.value = true;
        // Execute the GraphQL mutation with variables
        final response =
            await hasuraConnect.mutation(docQuery, variables: variables);
        final responseData = response['data'];

        // Extract the access token from the response
        final accessToken = responseData['login']['accessToken'];

        // Store the access token securely (e.g., using secure storage like Hive)
        final box = Hive.box('sekopercinta');
        box.put('token', accessToken);

        // Update the authentication state with the access token
        isLoadingSignIn.value = false;
        // final userData = context.read(userDataProvider);
        // if (userData.namaPengguna == null) {
        //   Navigator.pushReplacement(
        //       context, createRoute(page: const SignUpSetupPage()));
        // } else {
        //   Navigator.pushAndRemoveUntil(context,
        //       createRoute(page: const BottomNavPage()), (route) => false);
        // }
      } catch (error) {
        isLoadingSignIn.value = false;
        logger.e('Failed to login: $error');
        rethrow;
      }
    }

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
              // isLoadingSignIn.value
              //     ? const Center(child: CircularProgressIndicator())
              //     : BorderedButton(
              //         text: 'Masuk dengan Google',
              //         leading: Image.asset(
              //           'assets/images/ic-google.png',
              //           width: 20,
              //         ),
              //         onTap: () {},
              //       ),
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
              // BorderedButton(
              //   text: 'Masuk dengan email',
              //   color: accentColor,
              //   textColor: accentColor,
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const SignInEmailPage(),
              //       ),
              //     );
              //   },
              //   leading: Container(),
              // ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignInEmailPage2()));
                },
                child: const Text('Masuk dengan email'),
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
              // SingleChildScrollView(
              //   child: Column(
              //     children: [
              // FillButton(
              //   text: 'Daftar Sekarang',
              //   onTap: () {
              //     // Use SchedulerBinding.instance!.addPostFrameCallback() to perform navigation after the current frame is built
              //     // WidgetsBinding.instance.addPostFrameCallback((_) {
              //     Navigator.push(
              //       context,
              //       createRoute(
              //         page: const SignUpPage(),
              //       ),
              //     );
              //     // });
              //   },
              //   leading: Container(),
              // ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpPage()));
                },
                child: const Text('Daftar Sekarang'),
              ),

              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
