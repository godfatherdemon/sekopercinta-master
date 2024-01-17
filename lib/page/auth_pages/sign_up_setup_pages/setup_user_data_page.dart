import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta/components/text_field/drop_down_text_field.dart';
import 'package:sekopercinta/page/auth_pages/sign_up_setup_pages/search_address_page.dart';
import 'package:sekopercinta/providers/user_data.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';

class SetupUserDataPage extends HookWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;

  SetupUserDataPage({
    required this.pageController,
    required this.currentPage,
  });
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _userData = useState<Map<String, dynamic>>({});
    final _birthTextEditingController = useTextEditingController();
    final _addressTextEditingController = useTextEditingController();
    final _addressLatitude = useState<double?>(null);
    final _addressLongitude = useState<double?>(null);
    final _status = useState<String?>(null);

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              if (!_formKey.value.currentState!.validate()) {
                return;
              }

              _formKey.value.currentState?.save();

              print(_userData.value);

              _userData.value['alamat_geom'] = {
                "type": "Point",
                "coordinates": [_addressLongitude.value, _addressLatitude.value]
              };

              try {
                _isLoading.value = true;

                await context.read(userDataProvider.notifier).setUserData(
                      _userData.value,
                      context.read(hasuraClientProvider).state,
                    );

                currentPage.value++;
                pageController.animateToPage(
                  currentPage.value,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } catch (error) {
                _isLoading.value = false;
                throw error;
              }
            },
        []);
    return Form(
      key: _formKey.value,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
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
                height: 20,
              ),
              Text(
                'Tentang Anda',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Beritahu kami sedikit tentang Anda. Kami akan menyusun kurikulum yang sesuai dengan profil  Anda',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 24,
              ),
              BorderedFormField(
                hint: 'NIK',
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _userData.value['nik'] = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                },
                initialValue: '',
                focusNode: FocusNode(),
                onFieldSubmitted: (string) {},
                maxLine: 999,
                textEditingController: TextEditingController(),
                onChanged: (string) {},
                onTap: () {},
                suffixIcon: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _birthTextEditingController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                child: IgnorePointer(
                  child: BorderedFormField(
                    hint: 'Tanggal Lahir',
                    textEditingController: _birthTextEditingController,
                    suffixIcon: Container(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Image.asset(
                          'assets/images/ic-calendar.png',
                          width: 24,
                        ),
                      ),
                    ),
                    onSaved: (value) {
                      _userData.value['tanggal_lahir'] = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Tanggal lahir tidak boleh kosong';
                      }
                    },
                    initialValue: '',
                    focusNode: FocusNode(),
                    onFieldSubmitted: (string) {},
                    maxLine: 999,
                    onChanged: (string) {},
                    onTap: _submit,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownTextField(
                // value: _status,
                value: ValueNotifier<String>(_status.value ?? ''),
                hint: 'Status Pernikahan',
                listString: ['Belum Kawin', 'Sudah Kawin'],
                onSaved: (value) {
                  _userData.value['status_pernikahan'] = value == 'Sudah Kawin';
                },
                validator: (value) {
                  if (value == null) {
                    return 'Status pernikahan tidak boleh kosong';
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              BorderedFormField(
                hint: 'Alamat Anda',
                textEditingController: _addressTextEditingController,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _userData.value['alamat'] = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                },
                initialValue: '',
                focusNode: FocusNode(),
                onFieldSubmitted: (string) {},
                maxLine: 999,
                onChanged: (string) {},
                onTap: () {},
                suffixIcon: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var selectedAddress = await Navigator.of(context).push(
                    createRoute(page: SearchAddressPage()),
                  );

                  if (selectedAddress != null) {
                    if (_addressTextEditingController.text.isEmpty) {
                      _addressTextEditingController.text =
                          selectedAddress.addressLine;
                    }

                    _addressLatitude.value =
                        selectedAddress.coordinates.latitude;
                    _addressLongitude.value =
                        selectedAddress.coordinates.longitude;
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: FadeInImage(
                        image: (_addressLatitude.value == null ||
                                _addressLongitude.value == null)
                            ? NetworkImage(
                                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/107.61889487477076,-6.902195184720948,15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw')
                            : NetworkImage(
                                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${_addressLongitude.value},${_addressLatitude.value},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw'),
                        placeholder:
                            AssetImage('assets/images/bg-pattern-icon.png'),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_location_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Icon(
                    (_addressLatitude.value == null ||
                            _addressLongitude.value == null)
                        ? Icons.error_outline
                        : Icons.check_circle_outline_rounded,
                    color: (_addressLatitude.value == null ||
                            _addressLongitude.value == null)
                        ? primaryBlack
                        : accentColor,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    (_addressLatitude.value == null ||
                            _addressLongitude.value == null)
                        ? 'Belum ditambahkan pada peta'
                        : 'Telah ditambahkan pada peta',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: (_addressLatitude.value == null ||
                              _addressLongitude.value == null)
                          ? primaryBlack
                          : accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 109,
              ),
              FillButton(
                text: 'Lanjutkan',
                onTap: _submit,
                isLoading: _isLoading.value,
                leading: Container(),
              ),
              const SizedBox(
                height: 16,
              ),
              FillButton(
                color: Colors.transparent,
                textColor: accentColor,
                text: 'Kembali',
                onTap: () {
                  Navigator.of(context).pop();
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
