import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/page/auth_pages/sign_up_page.dart';
import 'package:sekopercinta/page/bottom_nav_pages/bottom_nav_page.dart';
import 'package:sekopercinta/providers/auth.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class SignInEmailPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _loginData = useState<Map<String, String>>({});
    final _passFocusNode = useFocusNode();
    final _isLoading = useState(false);

    final _submit = useMemoized(
      () => () async {
        if (!_formKey.value.currentState!.validate()) {
          return;
        }

        _formKey.value.currentState?.save();

        _isLoading.value = true;

        try {
          await context.read(authProvider.notifier).login(
                _loginData.value,
                context.read(hasuraClientProvider).state,
              );

          Navigator.pushAndRemoveUntil(
              context, createRoute(page: BottomNavPage()), (route) => false);
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
              title: 'Masuk',
              isBackIcon: true,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                        BorderedFormField(
                          hint: 'Email',
                          onSaved: (value) {
                            _loginData.value['email'] = value;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_passFocusNode);
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
                          focusNode: _passFocusNode,
                          obscureText: true,
                          maxLine: 1,
                          onSaved: (value) {
                            _loginData.value['password'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                          },
                          onFieldSubmitted: (value) {
                            _submit();
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
                        _isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : FillButton(
                                text: 'Masuk',
                                onTap: _submit,
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
