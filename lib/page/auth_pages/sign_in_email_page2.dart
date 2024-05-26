import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
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

class SignInEmailPage2 extends HookWidget {
  // const SignInEmailPage2({super.key});
  const SignInEmailPage2({Key? key}) : super(key: key);

  // BuildContext? get navigatorContext => null;
  // final JsObject navigatorContext = context;

  Future<void> Function() useCallback(
    Future<void> Function() callback,
    List<Object> dependencies,
  ) {
    final previousDependencies = useState<List<Object>>([]);
    final previousCallback = useState<Future<void> Function()>(() {
      // Dummy function to avoid returning null
      return Future.value();
    });

    if (!_listEquals(previousDependencies.value, dependencies)) {
      previousDependencies.value = dependencies;
      previousCallback.value = callback;
    }

    return previousCallback.value;
  }

  bool _listEquals(List<Object> a, List<Object> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    // final formKey = useMemoized(() => GlobalKey<FormState>());
    final loginData = useState<Map<String, String>>({});
    final passFocusNode = useFocusNode();
    final isLoading = useState(false);
    final navigatorKey = useMemoized(() => GlobalKey<NavigatorState>());

    final submit = useCallback(() async {
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

        navigatorKey.currentState!.pushAndRemoveUntil(
          createRoute(page: const BottomNavPage()),
          (route) => false,
        );
      } catch (error) {
        isLoading.value = false;
        rethrow;
      }
    }, [
      formKey,
      loginData,
      isLoading,
      authProvider,
      hasuraClientProvider,
      navigatorKey
    ]);
    // final submit = useMemoized(
    //   () => () async {
    //     if (!formKey.value.currentState!.validate()) {
    //       return;
    //     }

    //     formKey.value.currentState?.save();

    //     isLoading.value = true;

    //     try {
    //       await context
    //           .read(authProvider.notifier)
    //           .login(
    //             loginData.value,
    //             context.read(hasuraClientProvider).state,
    //           )
    //           .then((_) {
    //         navigatorKey.currentState!.pushAndRemoveUntil(
    //           createRoute(page: const BottomNavPage()),
    //           (route) => false,
    //         );
    //       }).catchError((error) {
    //         isLoading.value = false;
    //         // rethrow;
    //       });

    //       // Navigator.pushAndRemoveUntil(
    //       //     context, createRoute(page: BottomNavPage()), (route) => false);
    //       // Use the captured context inside the asynchronous operation
    //       // Navigator.pushAndRemoveUntil(
    //       //   context,
    //       //   createRoute(page: const BottomNavPage()),
    //       //   (route) => false,
    //       // );
    //       // navigatorKey.currentState!.pushAndRemoveUntil(
    //       //   createRoute(page: const BottomNavPage()),
    //       //   (route) => false,
    //       // );
    //     } catch (error) {
    //       isLoading.value = false;
    //       rethrow;
    //     }
    //   },
    // );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const PopAppBar(
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
                        // BorderedFormField(
                        //   hint: 'Email',
                        //   onSaved: (value) {
                        //     loginData.value['email'] = value;
                        //   },
                        //   onFieldSubmitted: (value) {
                        //     FocusScope.of(context).requestFocus(passFocusNode);
                        //   },
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Email tidak boleh kosong';
                        //     }
                        //     return null;
                        //   },
                        //   keyboardType: TextInputType.emailAddress,
                        //   textInputAction: TextInputAction.next,
                        //   textEditingController: TextEditingController(),
                        //   initialValue: '',
                        //   focusNode: FocusNode(),
                        //   maxLine: 999,
                        //   onChanged: (String? string) {
                        //     // print('Value changed: $string');
                        //     final Logger logger = Logger();
                        //     logger.i('Value changed: $string');
                        //   },
                        //   onTap: () {},
                        //   suffixIcon: Container(),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // BorderedFormField(
                        //   hint: 'Password',
                        //   focusNode: passFocusNode,
                        //   obscureText: true,
                        //   maxLine: 1,
                        //   onSaved: (value) {
                        //     loginData.value['password'] = value;
                        //   },
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Password tidak boleh kosong';
                        //     }
                        //     return null;
                        //   },
                        //   onFieldSubmitted: (value) {
                        //     submit();
                        //   },
                        //   textEditingController: TextEditingController(),
                        //   initialValue: '',
                        //   onChanged: (String? string) {},
                        //   onTap: () {},
                        //   suffixIcon: Container(),
                        // ),
                        // const SizedBox(
                        //   height: 32,
                        // ),
                        TextFormField(
                          // onTap: onTap,
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
                            labelText: 'hint',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: const Text(''),
                          ),
                          onFieldSubmitted: (value) {},
                          onChanged: (value) {},
                          // onSaved: onSaved,
                          onSaved: (newValue) {},
                          validator: (value) {
                            return null;
                          },
                          // validator:
                          //     validator as String? Function(String?)? ?? (String? value) => null,
                        ),
                        isLoading.value
                            ? const Center(
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
                                    Navigator.of(context).push(
                                        createRoute(page: const SignUpPage()));
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
