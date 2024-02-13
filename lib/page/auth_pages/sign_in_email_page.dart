import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_page.dart';
import 'package:sekopercinta_master/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class SignInEmailPage extends HookWidget {
  const SignInEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final loginData = useState<Map<String, String>>({});
    final passFocusNode = useFocusNode();
    final isLoading = useState(false);

    final submit = useMemoized(
      () => () async {
        if (!formKey.value.currentState!.validate()) {
          return;
        }

        formKey.value.currentState?.save();

        isLoading.value = true;

        try {
          await context.read(authProvider.notifier).login(
                loginData.value,
                context.read(hasuraClientProvider).state,
              );

          Navigator.pushAndRemoveUntil(
              context, createRoute(page: BottomNavPage()), (route) => false);
        } catch (error) {
          isLoading.value = false;
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
              title: 'Masuk',
              isBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                        BorderedFormField(
                          hint: 'Email',
                          onSaved: (value) {
                            loginData.value['email'] = value;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(passFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textEditingController: TextEditingController(),
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
                          hint: 'Password',
                          focusNode: passFocusNode,
                          obscureText: true,
                          maxLine: 1,
                          onSaved: (value) {
                            loginData.value['password'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                          },
                          onFieldSubmitted: (value) {
                            submit();
                          },
                          textEditingController: TextEditingController(),
                          initialValue: '',
                          onChanged: (string) {},
                          onTap: () {},
                          suffixIcon: Container(),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : FillButton(
                                text: 'Masuk',
                                onTap: submit,
                                leading: Container(),
                              ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Belum punya akun?',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: ' Daftar',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(createRoute(page: SignUpPage()));
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Lupa password Anda? Klik',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: ' Disini',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
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
