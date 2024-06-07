import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final userData = useState<UserData>(context.read(userDataProvider));
    final editedUserData = useState<Map<String, dynamic>>({});

    final birthTextEditingController = useTextEditingController(
      // text: DateFormat('dd MMMM yyyy').format(_userData.value.tanggalLahir));
      text: userData.value.tanggalLahir != null
          ? DateFormat('dd MMMM yyyy').format(userData.value.tanggalLahir!)
          : '', // Provide a default value or handle the null case
    );

    final addressTextEditingController =
        useTextEditingController(text: userData.value.alamat);

    final status = useState<String>(
        userData.value.statusPernikahan ? 'Sudah Kawin' : 'Belum Kawin');

    // final _addressLatitude = useState<double>(_userData.value.alamatGeom != null
    //     ? _userData.value.alamatGeom.coordinates.last
    //     : null);

    final addressLatitude = useState<double>(
      userData.value.alamatGeom?.coordinates.last ?? 0.0,
    );

    // final _addressLongitude = useState<double>(
    //     _userData.value.alamatGeom != null
    //         ? _userData.value.alamatGeom.coordinates.first
    //         : null);

    final addressLongitude = useState<double>(
      userData.value.alamatGeom?.coordinates.first ?? 0.0,
    );

    // final _selectedProfileFile = useState<File>(null);
    final selectedProfileFile = useState<File?>(null);
    // final _selectedProfileFile = useState<File>(File('default_file_path'));

    final isLoading = useState(false);

    final submit = useMemoized(
        () => () async {
              final formKeyValue = formKey.value;
              final selectedProfileFileValue = selectedProfileFile.value;
              final hasuraClientState =
                  context.read(hasuraClientProvider).state;
              final userDataNotifier = context.read(userDataProvider.notifier);
              final navigator = Navigator.of(context);

              if (!formKeyValue.currentState!.validate()) {
                return;
              }

              formKeyValue.currentState?.save();
              isLoading.value = true;

              try {
                if (selectedProfileFileValue != null) {
                  await userDataNotifier.uploadProfile(
                    selectedProfileFileValue,
                    hasuraClientState,
                  );
                }

                final Logger logger = Logger();
                logger.d(userData.value);

                editedUserData.value['alamat_geom'] = {
                  "type": "Point",
                  "coordinates": [addressLongitude.value, addressLatitude.value]
                };

                await userDataNotifier.setUserData(
                  editedUserData.value,
                  hasuraClientState,
                );

                // Navigator.of(context).pop('edit');
                navigator.pop('edit');
              } catch (error) {
                isLoading.value = false;
                rethrow;
              }

              // if (!formKey.value.currentState!.validate()) {
              //   return;
              // }

              // formKey.value.currentState?.save();
              // isLoading.value = true;

              // try {
              //   if (selectedProfileFile.value != null) {
              //     // await context.read(userDataProvider.notifier).uploadProfile(
              //     //       _selectedProfileFile.value,
              //     //       context.read(hasuraClientProvider).state,
              //     //     );
              //     await context.read(userDataProvider.notifier).uploadProfile(
              //           selectedProfileFile.value!,
              //           context.read(hasuraClientProvider).state,
              //         );
              //   }

              //   // print(userData.value);
              //   final Logger logger = Logger();
              //   logger.d(userData.value);

              //   editedUserData.value['alamat_geom'] = {
              //     "type": "Point",
              //     "coordinates": [addressLongitude.value, addressLatitude.value]
              //   };

              //   await context.read(userDataProvider.notifier).setUserData(
              //         editedUserData.value,
              //         context.read(hasuraClientProvider).state,
              //       );

              //   Navigator.of(context).pop('edit');
              // } catch (error) {
              //   isLoading.value = false;
              //   rethrow;
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
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: primaryBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey.value,
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
                                      child: selectedProfileFile.value == null
                                          ? userData.value.fotoProfil!
                                                  .contains('http')
                                              ? Image.network(
                                                  // _userData.value.fotoProfil,
                                                  // fit: BoxFit.cover,
                                                  // height: 80,
                                                  // width: 80,
                                                  userData.value.fotoProfil ??
                                                      'https://placeholder.com/80x80', // replace with your default image URL
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                )
                                              : Image.asset(
                                                  userData.value.fotoProfil ==
                                                          '{{default_1}}'
                                                      ? 'assets/images/img-women-a.png'
                                                      : userData.value
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
                                              selectedProfileFile.value ??
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
                                                        page:
                                                            const CameraPage()));

                                            if (selectedFilePath != null) {
                                              selectedProfileFile.value =
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

                                              selectedProfileFile.value = file;
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
                            // BorderedFormField(
                            //   hint: 'NIK',
                            //   initialValue: userData.value.nik,
                            //   keyboardType: TextInputType.number,
                            //   textEditingController: TextEditingController(),
                            //   onSaved: (value) {
                            //     editedUserData.value['nik'] = value;
                            //   },
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'NIK tidak boleh kosong';
                            //     }
                            //     return null;
                            //   },
                            //   focusNode: FocusNode(),
                            //   onFieldSubmitted: (string) {},
                            //   maxLine: 999,
                            //   onChanged: (string) {},
                            //   onTap: () {},
                            //   suffixIcon: Container(),
                            // ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'NIK',
                                border: const OutlineInputBorder(),
                                suffixIcon: Container(),
                              ),
                              initialValue: userData.value.nik,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                editedUserData.value['nik'] = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'NIK tidak boleh kosong';
                                }
                                return null;
                              },
                              focusNode: FocusNode(),
                              onFieldSubmitted: (value) {},
                              maxLines: 1,
                              onChanged: (value) {},
                              onTap: () {},
                              controller: TextEditingController(),
                            ),

                            const SizedBox(
                              height: 12,
                            ),
                            // BorderedFormField(
                            //   hint: 'Nama',
                            //   // initialValue: _userData.value.namaPengguna,
                            //   initialValue: userData.value.namaPengguna ?? '',
                            //   onSaved: (value) {
                            //     editedUserData.value['nama_pengguna'] = value;
                            //   },
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'Nama tidak boleh kosong';
                            //     }
                            //     return null;
                            //   },
                            //   focusNode: FocusNode(),
                            //   onFieldSubmitted: (string) {},
                            //   maxLine: 999,
                            //   onChanged: (string) {},
                            //   onTap: () {},
                            //   suffixIcon: Container(),
                            //   textEditingController: TextEditingController(),
                            // ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Nama',
                                border: const OutlineInputBorder(),
                                suffixIcon: Container(),
                              ),
                              initialValue: userData.value.namaPengguna ?? '',
                              onSaved: (value) {
                                editedUserData.value['nama_pengguna'] = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                              focusNode: FocusNode(),
                              onFieldSubmitted: (value) {},
                              maxLines: 1,
                              onChanged: (value) {},
                              onTap: () {},
                              controller: TextEditingController(),
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
                                  birthTextEditingController.text =
                                      DateFormat('yyyy-MM-dd').format(picked);
                                }
                              },
                              child: IgnorePointer(
                                // child: BorderedFormField(
                                //   hint: 'Tanggal Lahir',
                                //   textEditingController:
                                //       birthTextEditingController,
                                //   suffixIcon: SizedBox(
                                //     width: 32,
                                //     height: 32,
                                //     child: Center(
                                //       child: Image.asset(
                                //         'assets/images/ic-calendar.png',
                                //         width: 24,
                                //       ),
                                //     ),
                                //   ),
                                //   onSaved: (value) {
                                //     editedUserData.value['tanggal_lahir'] =
                                //         value;
                                //   },
                                //   validator: (value) {
                                //     if (value!.isEmpty) {
                                //       return 'Tanggal lahir tidak boleh kosong';
                                //     }
                                //     return null;
                                //   },
                                //   initialValue: '',
                                //   focusNode: FocusNode(),
                                //   onFieldSubmitted: (string) {},
                                //   maxLine: 999,
                                //   onChanged: (string) {},
                                //   onTap: () {},
                                // ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Tanggal Lahir',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/ic-calendar.png',
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  controller: birthTextEditingController,
                                  onSaved: (value) {
                                    editedUserData.value['tanggal_lahir'] =
                                        value!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tanggal lahir tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  focusNode: FocusNode(),
                                  onFieldSubmitted: (value) {},
                                  maxLines:
                                      1, // Setting maxLines to 1 for a single-line input
                                  onChanged: (value) {},
                                  onTap: () {},
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            DropDownTextField(
                              value: status,
                              hint: 'Status Pernikahan',
                              listString: const ['Belum Kawin', 'Sudah Kawin'],
                              onSaved: (value) {
                                editedUserData.value['status_pernikahan'] =
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
                              value: useState(userData.value.pendidikanTerakhir!
                                  .toUpperCase()),
                              hint: 'Tingkat Pendidikan',
                              listString: const [
                                'SD',
                                'SMP',
                                'SMA',
                                'SMK',
                                'PT',
                                'DO'
                              ],
                              onSaved: (value) {
                                editedUserData.value['pendidikan_terakhir'] =
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
                            // BorderedFormField(
                            //   hint: 'Alamat',
                            //   textEditingController:
                            //       addressTextEditingController,
                            //   onSaved: (value) {
                            //     editedUserData.value['alamat'] = value;
                            //   },
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return 'Alamat tidak boleh kosong';
                            //     }
                            //     return null;
                            //   },
                            //   initialValue: '',
                            //   focusNode: FocusNode(),
                            //   onFieldSubmitted: (string) {},
                            //   maxLine: 999,
                            //   onChanged: (string) {},
                            //   onTap: () {},
                            //   suffixIcon: Container(),
                            // ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Alamat',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    Container(), // Empty container as suffixIcon
                              ),
                              controller: addressTextEditingController,
                              onSaved: (value) {
                                editedUserData.value['alamat'] = value!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Alamat tidak boleh kosong';
                                }
                                return null;
                              },
                              focusNode: FocusNode(),
                              onFieldSubmitted: (value) {},
                              maxLines: null, // null allows for multiline input
                              onChanged: (value) {},
                              onTap: () {},
                            ),

                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () async {
                                var selectedAddress =
                                    await Navigator.of(context).push(
                                  createRoute(page: const SearchAddressPage()),
                                );

                                if (selectedAddress != null) {
                                  if (addressTextEditingController
                                      .text.isEmpty) {
                                    addressTextEditingController.text =
                                        selectedAddress.addressLine;
                                  }

                                  addressLatitude.value =
                                      selectedAddress.coordinates.latitude;
                                  addressLongitude.value =
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
                                          'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${addressLongitude.value},${addressLatitude.value},15,0,0/400x400?access_token=pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw'),
                                      placeholder: const AssetImage(
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
                                          child: const Icon(
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
                      isLoading: isLoading.value,
                      onTap: submit,
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
