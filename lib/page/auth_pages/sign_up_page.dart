import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/components/custom_button/bordered_button.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/page/auth_pages/on_boarding_sign_up_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_in_email_page.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final signUpData = useState<Map<String, String>>({});
    final passTextEditingController = useTextEditingController();

    final passFocusNode = useFocusNode();
    final passFocusNode2 = useFocusNode();
    final isLoading = useState(false);

    // final isLoadingGoogleSignIn = useState(false);

    // final googleSignIn = useMemoized(
    //   () => () async {
    //     final navigator = Navigator.of(context);

    //     final authNotifier = context.read(authProvider.notifier);
    //     // final authNotifier = context.read(authProvider);

    //     final authState = context.read(authProvider);
    //     final userDataNotifier = context.read(userDataProvider.notifier);
    //     final hasuraClientState = context.read(hasuraClientProvider).state;
    //     // isLoadingGoogleSignIn.value = true;

    //     try {
    //       // await context.read(authProvider.notifier).googleSignIn();
    //       isLoadingGoogleSignIn.value = true;
    //       await authNotifier.googleSignIn();

    //       // if (context.read(authProvider).isEmpty) {
    //       //   isLoadingGoogleSignIn.value = false;
    //       //   return;
    //       // }

    //       // if (authNotifier.isEmpty) {
    //       //   isLoadingGoogleSignIn.value = false;
    //       //   return;
    //       // }

    //       if (authState.isEmpty) {
    //         isLoadingGoogleSignIn.value = false;
    //         return;
    //       }

    //       // await context.read(userDataProvider.notifier).getUserData(
    //       //       context.read(hasuraClientProvider).state,
    //       //     );

    //       await userDataNotifier.getUserData(hasuraClientState);

    //       isLoadingGoogleSignIn.value = false;

    //       // final userData = context.read(userDataProvider);
    //       final userData = userDataProvider;
    //       if (userData.name == null) {
    //         // Navigator.pushReplacement(
    //         //   context,
    //         //   createRoute(page: const SignUpSetupPage()),
    //         // );
    //         navigator.pushReplacement(
    //           createRoute(page: const SignUpSetupPage()),
    //         );

    //         // Navigator.of(context).pushReplacement(createRoute(
    //         //   page: const SignUpSetupPage(),
    //         //   isVertical: true,
    //         // ));
    //       } else {
    //         // Navigator.pushAndRemoveUntil(
    //         //   context,
    //         //   createRoute(page: const BottomNavPage()),
    //         //   (route) => false,
    //         // );
    //         navigator.pushAndRemoveUntil(
    //           createRoute(page: const BottomNavPage()),
    //           (route) => false,
    //         );
    //       }
    //       // if (context.read(userDataProvider).namaPengguna == null) {
    //       //   Navigator.pushReplacement(
    //       //       context, createRoute(page: const SignUpSetupPage()));
    //       // } else {
    //       //   Navigator.pushAndRemoveUntil(context,
    //       //       createRoute(page: const BottomNavPage()), (route) => false);
    //       // }
    //     } catch (error) {
    //       isLoadingGoogleSignIn.value = false;
    //       rethrow;
    //     }

    //     // Navigator.pushReplacement(
    //     //     context, createRoute(page: SignUpSetupPage()));
    //   },
    // );

    final submit = useMemoized(
      () => () async {
        final navigator = Navigator.of(context);
        if (!formKey.value.currentState!.validate()) {
          return;
        }

        formKey.value.currentState?.save();

        isLoading.value = true;

        try {
          await context.read(authProvider.notifier).signUp(
                signUpData.value,
                context.read(hasuraClientProvider).state,
              );

          // Navigator.of(context).pushReplacement(createRoute(
          //     page: const OnBoardingSignUpPage(), arguments: signUpData.value));
          navigator.pushReplacement(
            createRoute(
              page: const OnBoardingSignUpPage(),
              arguments: signUpData.value,
            ),
          );
        } catch (error) {
          isLoading.value = false;
          rethrow;
        }
      },
      [formKey.value, signUpData.value],
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const PopAppBar(
              title: 'Daftar',
              isBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Daftarkan diri Anda dan Ikuti Sekoper Cinta',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        // BorderedFormField(
                        TextFormField(
                          // hint: 'Email',
                          onTap: () {},
                          cursorColor: Colors.black,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFBDBDBD), width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: accentColor, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 12, bottom: 12, top: 12, right: 12),
                            labelText: 'email',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: const Text(''),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            signUpData.value['email'] = value!;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(passFocusNode);
                          },
                          // textEditingController: TextEditingController(),
                          // textEditingController: passTextEditingController,
                          initialValue: '',
                          focusNode: FocusNode(),
                          // maxLine: 999,
                          onChanged: (string) {},
                          // suffixIcon: Container(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // BorderedFormField(
                        //   hint: 'Buat Password',
                        //   obscureText: true,
                        //   maxLine: 1,
                        //   focusNode: passFocusNode,
                        //   textEditingController: passTextEditingController,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Password tidak boleh kosong';
                        //     }
                        //     if (value.length < 8) {
                        //       return 'Password harus 8 huruf atau lebih';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (value) {
                        //     signUpData.value['password'] = value;
                        //   },
                        //   onFieldSubmitted: (value) {
                        //     FocusScope.of(context).requestFocus(passFocusNode2);
                        //   },
                        //   initialValue: '',
                        //   onChanged: (string) {},
                        //   onTap: () {},
                        //   // onTap: null,
                        //   suffixIcon: Container(),
                        // ),
                        TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFBDBDBD), width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: accentColor, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 12, bottom: 12, top: 12, right: 12),
                            labelText: 'password',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: const Text(''),
                          ),
                          obscureText: true,
                          maxLines: 1,
                          focusNode: passFocusNode2,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value != passTextEditingController.text) {
                              return 'Password tidak sesuai';
                            }
                            if (value.length < 8) {
                              return 'Password harus 8 huruf atau lebih';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            submit();
                          },
                          controller: passTextEditingController,
                          onChanged: (value) {
                            signUpData.value['password'] = value;
                          },
                          onSaved: (string) {},
                          onTap: submit,
                          // If you need a suffix icon, you can add it like this:
                          // suffixIcon: const Icon(Icons.visibility_off), // or any other widget
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // BorderedFormField(
                        //   hint: 'Ulangi Password',
                        //   obscureText: true,
                        //   maxLine: 1,
                        //   focusNode: passFocusNode2,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Password tidak boleh kosong';
                        //     }
                        //     if (value != passTextEditingController.text) {
                        //       return 'Password tidak sesuai';
                        //     }
                        //     if (value.length < 8) {
                        //       return 'Password harus 8 huruf atau lebih';
                        //     }
                        //     return null;
                        //   },
                        //   onFieldSubmitted: (value) {
                        //     submit();
                        //   },
                        //   textEditingController: passTextEditingController,
                        //   initialValue: '',
                        //   onChanged: (string) {},
                        //   onSaved: (string) {},
                        //   onTap: submit,
                        //   suffixIcon: Container(),
                        // ),
                        TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFBDBDBD), width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: accentColor, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 12, bottom: 12, top: 12, right: 12),
                            labelText: 'ulangi password',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: const Text(''),
                          ),
                          obscureText: true,
                          maxLines: 1,
                          focusNode: passFocusNode2,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value != passTextEditingController.text) {
                              return 'Password tidak sesuai';
                            }
                            if (value.length < 8) {
                              return 'Password harus 8 huruf atau lebih';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            submit();
                          },
                          controller: passTextEditingController,
                          onChanged: (value) {
                            signUpData.value['password'] = value;
                          },
                          onSaved: (string) {},
                          onTap: submit,
                          // If you need a suffix icon, you can add it like this:
                          // suffixIcon: const Icon(Icons.visibility_off), // or any other widget
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : FillButton(
                                text: 'Daftar Sekarang',
                                onTap: submit,
                                leading: Container(),
                              ),
                        const SizedBox(
                          height: 24,
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                'Dengan mendaftarkan diri anda telah menyetujui ',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: 'Syarat dan Ketentuan ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(text: 'serta '),
                              TextSpan(
                                text: 'Kebijakan Privasi ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(text: 'Sekoper Cinta'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Sudah punya akun?',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: ' Masuk',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(createRoute(
                                        page: const SignInEmailPage()));
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: Text(
                            'atau',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: primaryGrey,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        // isLoadingGoogleSignIn.value
                        //     ? const Center(child: CircularProgressIndicator())
                        //     : BorderedButton(
                        //         text: 'Masuk dengan Google',
                        //         leading: Image.asset(
                        //           'assets/images/ic-google.png',
                        //           width: 20,
                        //         ),
                        //         onTap: googleSignIn,
                        //       ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
