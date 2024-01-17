import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta/components/custom_button/bordered_button.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/page/auth_pages/on_boarding_sign_up_page.dart';
import 'package:sekopercinta/page/auth_pages/sign_in_email_page.dart';
import 'package:sekopercinta/page/auth_pages/sign_up_setup_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class SignUpPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _signUpData = useState<Map<String, String>>({});
    final _passTextEditingController = useTextEditingController();

    final _passFocusNode = useFocusNode();
    final _passFocusNode2 = useFocusNode();
    final _isLoading = useState(false);

    final _isLoadingGoogleSignIn = useState(false);

    final _googleSignIn = useMemoized(
      () => () async {
        _isLoadingGoogleSignIn.value = true;

        try {
          await context.read(authProvider.notifier).googleSignIn();

          if (context.read(authProvider).isEmpty) {
            _isLoadingGoogleSignIn.value = false;
            return;
          }

          await context.read(userDataProvider.notifier).getUserData(
                context.read(hasuraClientProvider).state,
              );

          _isLoadingGoogleSignIn.value = false;

          if (context.read(userDataProvider).namaPengguna == null) {
            Navigator.pushReplacement(
                context, createRoute(page: SignUpSetupPage()));
          } else {
            Navigator.pushAndRemoveUntil(
                context, createRoute(page: BottomNavPage()), (route) => false);
          }
        } catch (error) {
          _isLoadingGoogleSignIn.value = false;
          throw error;
        }

        // Navigator.pushReplacement(
        //     context, createRoute(page: SignUpSetupPage()));
      },
    );

    final _submit = useMemoized(
      () => () async {
        if (!_formKey.value.currentState!.validate()) {
          return;
        }

        _formKey.value.currentState?.save();

        _isLoading.value = true;

        try {
          await context.read(authProvider.notifier).signUp(
                _signUpData.value,
                context.read(hasuraClientProvider).state,
              );

          Navigator.of(context).pushReplacement(createRoute(
              page: OnBoardingSignUpPage(), arguments: _signUpData.value));
        } catch (error) {
          _isLoading.value = false;
          throw error;
        }
      },
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            PopAppBar(
              title: 'Daftar',
              isBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey.value,
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
                        BorderedFormField(
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                          },
                          onSaved: (value) {
                            _signUpData.value['email'] = value;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          // textEditingController: TextEditingController(),
                          textEditingController: _passTextEditingController,
                          initialValue: '',
                          focusNode: FocusNode(),
                          maxLine: 999,
                          onChanged: (string) {},
                          onTap: () {},
                          suffixIcon: Container(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BorderedFormField(
                          hint: 'Buat Password',
                          obscureText: true,
                          maxLine: 1,
                          focusNode: _passFocusNode,
                          textEditingController: _passTextEditingController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 8) {
                              return 'Password harus 8 huruf atau lebih';
                            }
                          },
                          onSaved: (value) {
                            _signUpData.value['password'] = value;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passFocusNode2);
                          },
                          initialValue: '',
                          onChanged: (string) {},
                          onTap: _submit,
                          // onTap: null,
                          suffixIcon: Container(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BorderedFormField(
                          hint: 'Ulangi Password',
                          obscureText: true,
                          maxLine: 1,
                          focusNode: _passFocusNode2,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value != _passTextEditingController.text) {
                              return 'Password tidak sesuai';
                            }
                            if (value.length < 8) {
                              return 'Password harus 8 huruf atau lebih';
                            }
                          },
                          onFieldSubmitted: (value) {
                            _submit();
                          },
                          textEditingController: _passTextEditingController,
                          initialValue: '',
                          onChanged: (string) {},
                          onSaved: (string) {},
                          onTap: _submit,
                          suffixIcon: Container(),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : FillButton(
                                text: 'Daftar Sekarang',
                                onTap: _submit,
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
                              TextSpan(text: 'serta '),
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
                              TextSpan(text: 'Sekoper Cinta'),
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
                                    Navigator.of(context).push(
                                        createRoute(page: SignInEmailPage()));
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
                        _isLoadingGoogleSignIn.value
                            ? Center(child: CircularProgressIndicator())
                            : BorderedButton(
                                text: 'Masuk dengan Google',
                                leading: Image.asset(
                                  'assets/images/ic-google.png',
                                  width: 20,
                                ),
                                onTap: _googleSignIn,
                              ),
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
