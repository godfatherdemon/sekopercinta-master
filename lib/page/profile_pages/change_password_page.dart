import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/providers/auth.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';

class ChangePasswordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _passTextEditingController = useTextEditingController();
    final _oldPassword = useState<String?>(null);
    final _newPassword = useState<String?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              if (!_formKey.value.currentState!.validate()) {
                return;
              }

              _formKey.value.currentState?.save();
              _isLoading.value = true;

              try {
                await context.read(authProvider.notifier).changePassword(
                      _newPassword.value ?? 'defaultPassword',
                      _oldPassword.value ?? 'defaultPassword',
                      context.read(hasuraClientProvider).state,
                    );
                Navigator.of(context).pop('edit');
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
            },
        []);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Ganti Password',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: primaryBlack,
          ),
        ),
      ),
      body: Form(
        key: _formKey.value,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -127,
                right: -95,
                child: Image.asset(
                  'assets/images/bg-blur.png',
                  color: primaryColor,
                  width: 241,
                ),
              ),
              Positioned(
                left: -127,
                bottom: 10,
                child: Image.asset(
                  'assets/images/bg-blur.png',
                  color: secondaryColor,
                  width: 241,
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 8,
                        shadowColor: primaryColor.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              BorderedFormField(
                                hint: 'Password lama',
                                obscureText: true,
                                maxLine: 1,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password lama tidak boleh kosong';
                                  }
                                },
                                onSaved: (value) {
                                  _oldPassword.value = value;
                                },
                                initialValue: '',
                                focusNode: FocusNode(),
                                onFieldSubmitted: (string) {},
                                onChanged: (string) {},
                                onTap: () {},
                                // suffixIcon: Container(),
                                suffixIcon: Icon(Icons.verified_user),
                                textEditingController: TextEditingController(),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              BorderedFormField(
                                hint: 'Password baru',
                                textEditingController:
                                    _passTextEditingController,
                                obscureText: true,
                                maxLine: 1,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password baru tidak boleh kosong';
                                  }
                                  if (value.length < 8) {
                                    return 'Password harus 8 huruf atau lebih';
                                  }
                                },
                                onSaved: (value) {
                                  _newPassword.value = value;
                                },
                                initialValue: '',
                                focusNode: FocusNode(),
                                onFieldSubmitted: (string) {},
                                onChanged: (string) {},
                                onTap: () {},
                                suffixIcon: Container(),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Password terdiri dari minimal ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    TextSpan(
                                      text: '8 karakter',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' dengan',
                                    ),
                                    TextSpan(
                                      text: ' kombinasi Huruf dan Angka',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              BorderedFormField(
                                hint: 'Konfirmasi password baru',
                                obscureText: true,
                                maxLine: 1,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  if (value !=
                                      _passTextEditingController.text) {
                                    return 'Password tidak sesuai';
                                  }
                                  if (value.length < 8) {
                                    return 'Password harus 8 huruf atau lebih';
                                  }
                                },
                                textEditingController:
                                    _passTextEditingController,
                                initialValue: '',
                                focusNode: FocusNode(),
                                onFieldSubmitted: (string) {},
                                onChanged: (string) {},
                                onSaved: (string) {},
                                suffixIcon: Container(),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      FillButton(
                        text: 'Simpan',
                        isLoading: _isLoading.value,
                        onTap: _submit,
                        leading: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
