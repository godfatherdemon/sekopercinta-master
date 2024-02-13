import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:sekopercinta_master/components/text_field/drop_down_text_field.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/search_address_page.dart';
import 'package:sekopercinta_master/page/camera_page/camera_page.dart';
import 'package:sekopercinta_master/providers/user_data.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta_master/utils/file_upload_handler.dart';
import 'package:sekopercinta_master/utils/hasura_config.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';

class EditProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useState(GlobalKey<FormState>());
    final _userData = useState<UserData>(context.read(userDataProvider));
    final _editedUserData = useState<Map<String, dynamic>>({});

    final _birthTextEditingController = useTextEditingController(
      // text: DateFormat('dd MMMM yyyy').format(_userData.value.tanggalLahir));
      text: _userData.value.tanggalLahir != null
          ? DateFormat('dd MMMM yyyy').format(_userData.value.tanggalLahir!)
          : '', // Provide a default value or handle the null case
    );

    final _addressTextEditingController =
        useTextEditingController(text: _userData.value.alamat);

    final _status = useState<String>(
        _userData.value.statusPernikahan ? 'Sudah Kawin' : 'Belum Kawin');

    // final _addressLatitude = useState<double>(_userData.value.alamatGeom != null
    //     ? _userData.value.alamatGeom.coordinates.last
    //     : null);

    final _addressLatitude = useState<double>(
      _userData.value.alamatGeom?.coordinates.last ?? 0.0,
    );

    // final _addressLongitude = useState<double>(
    //     _userData.value.alamatGeom != null
    //         ? _userData.value.alamatGeom.coordinates.first
    //         : null);

    final _addressLongitude = useState<double>(
      _userData.value.alamatGeom?.coordinates.first ?? 0.0,
    );

    // final _selectedProfileFile = useState<File>(null);
    final _selectedProfileFile = useState<File?>(null);
    // final _selectedProfileFile = useState<File>(File('default_file_path'));

    final _isLoading = useState(false);

    final _submit = useMemoized(
        () => () async {
              if (!_formKey.value.currentState!.validate()) {
                return;
              }

              _formKey.value.currentState?.save();
              _isLoading.value = true;

              try {
                if (_selectedProfileFile.value != null) {
                  // await context.read(userDataProvider.notifier).uploadProfile(
                  //       _selectedProfileFile.value,
                  //       context.read(hasuraClientProvider).state,
                  //     );
                  await context.read(userDataProvider.notifier).uploadProfile(
                        _selectedProfileFile.value!,
                        context.read(hasuraClientProvider).state,
                      );
                }

                print(_userData.value);

                _editedUserData.value['alamat_geom'] = {
                  "type": "Point",
                  "coordinates": [
                    _addressLongitude.value,
                    _addressLatitude.value
                  ]
                };

                await context.read(userDataProvider.notifier).setUserData(
                      _editedUserData.value,
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
          'Edit Profil',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
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
                Column(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: _selectedProfileFile.value == null
                                          ? _userData.value.fotoProfil!
                                                  .contains('http')
                                              ? Image.network(
                                                  // _userData.value.fotoProfil,
                                                  // fit: BoxFit.cover,
                                                  // height: 80,
                                                  // width: 80,
                                                  _userData.value.fotoProfil ??
                                                      'https://placeholder.com/80x80', // replace with your default image URL
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                )
                                              : Image.asset(
                                                  _userData.value.fotoProfil ==
                                                          '{{default_1}}'
                                                      ? 'assets/images/img-women-a.png'
                                                      : _userData.value
                                                                  .fotoProfil ==
                                                              '{{default_2}}'
                                                          ? 'assets/images/img-women-b.png'
                                                          : 'assets/images/img-women-c.png',
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 90,
                                                )
                                          : Image.file(
                                              // _selectedProfileFile.value,
                                              // fit: BoxFit.cover,
                                              // height: 80,
                                              // width: 80,
                                              _selectedProfileFile.value ??
                                                  File(
                                                      'path_to_default_image'), // replace with your default image file
                                              fit: BoxFit.cover,
                                              height: 80,
                                              width: 80,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () async {
                                        final action =
                                            await selectPhotoHandler(context);

                                        if (action == null) {
                                          return;
                                        }

                                        if (action == 'camera') {
                                          if (await Permission.camera
                                              .request()
                                              .isGranted) {
                                            final selectedFilePath =
                                                await Navigator.of(context)
                                                    .push(createRoute(
                                                        page: CameraPage()));

                                            if (selectedFilePath != null) {
                                              _selectedProfileFile.value =
                                                  File(selectedFilePath);
                                            }
                                          }
                                        } else {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'png',
                                              'jpeg'
                                            ],
                                          );

                                          // if (result != null) {
                                          //   File file =
                                          //       File(result.files.single.path);

                                          //   if (file.lengthSync() > 2097152) {
                                          //     Fluttertoast.showToast(
                                          //       msg:
                                          //           'File harus kurang dari 2 Mb',
                                          //     );
                                          //     return;
                                          //   }

                                          //   _selectedProfileFile.value = file;
                                          // }

                                          if (result != null &&
                                              result.files.isNotEmpty) {
                                            String? filePath =
                                                result.files.single.path;

                                            if (filePath != null) {
                                              File file = File(filePath);

                                              if (file.lengthSync() > 2097152) {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'File harus kurang dari 2 Mb',
                                                );
                                                return;
                                              }

                                              _selectedProfileFile.value = file;
                                            }
                                          }
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Image.asset(
                                            'assets/images/ic-edit-fill.png',
                                            width: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            BorderedFormField(
                              hint: 'NIK',
                              initialValue: _userData.value.nik,
                              keyboardType: TextInputType.number,
                              textEditingController: TextEditingController(),
                              onSaved: (value) {
                                _editedUserData.value['nik'] = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'NIK tidak boleh kosong';
                                }
                              },
                              focusNode: FocusNode(),
                              onFieldSubmitted: (string) {},
                              maxLine: 999,
                              onChanged: (string) {},
                              onTap: () {},
                              suffixIcon: Container(),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            BorderedFormField(
                              hint: 'Nama',
                              // initialValue: _userData.value.namaPengguna,
                              initialValue: _userData.value.namaPengguna ?? '',
                              onSaved: (value) {
                                _editedUserData.value['nama_pengguna'] = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                              },
                              focusNode: FocusNode(),
                              onFieldSubmitted: (string) {},
                              maxLine: 999,
                              onChanged: (string) {},
                              onTap: () {},
                              suffixIcon: Container(),
                              textEditingController: TextEditingController(),
                            ),
                            const SizedBox(
                              height: 12,
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
                                  textEditingController:
                                      _birthTextEditingController,
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
                                    _editedUserData.value['tanggal_lahir'] =
                                        value;
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
                                  onTap: () {},
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            DropDownTextField(
                              value: _status,
                              hint: 'Status Pernikahan',
                              listString: ['Belum Kawin', 'Sudah Kawin'],
                              onSaved: (value) {
                                _editedUserData.value['status_pernikahan'] =
                                    value == 'Sudah Kawin';
                              },
                              validator: (value) {
                                // if (value == null) {
                                //   return 'Status pernikahan tidak boleh kosong';
                                // }
                                if (value!.isEmpty) {
                                  return 'Status pernikahan tidak boleh kosong';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            DropDownTextField(
                              value: useState(_userData
                                  .value.pendidikanTerakhir!
                                  .toUpperCase()),
                              hint: 'Tingkat Pendidikan',
                              listString: [
                                'SD',
                                'SMP',
                                'SMA',
                                'SMK',
                                'PT',
                                'DO'
                              ],
                              onSaved: (value) {
                                _editedUserData.value['pendidikan_terakhir'] =
                                    value?.toLowerCase();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Tingkat pendidikan tidak boleh kosong';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            BorderedFormField(
                              hint: 'Alamat',
                              textEditingController:
                                  _addressTextEditingController,
                              onSaved: (value) {
                                _editedUserData.value['alamat'] = value;
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
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () async {
                                var selectedAddress =
                                    await Navigator.of(context).push(
                                  createRoute(page: SearchAddressPage()),
                                );

                                if (selectedAddress != null) {
                                  if (_addressTextEditingController
                                      .text.isEmpty) {
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
                                    // child: FadeInImage(
                                    //   image: (_addressLatitude.value == null ||
                                    //           _addressLongitude.value == null)
                                    //       ? NetworkImage(
                                    //           'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/107.61889487477076,-6.902195184720948,15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw')
                                    //       : NetworkImage(
                                    //           'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${_addressLongitude.value},${_addressLatitude.value},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw'),
                                    //   placeholder: AssetImage(
                                    //       'assets/images/bg-pattern-icon.png'),
                                    //   height: 120,
                                    //   width: double.infinity,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${_addressLongitude.value},${_addressLatitude.value},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw'),
                                      placeholder: AssetImage(
                                          'assets/images/bg-pattern-icon.png'),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
