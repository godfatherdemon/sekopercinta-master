import 'dart:convert';
import 'dart:io';

import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';

class UserData {
  UserData(
      {required this.alamat,
      this.alamatGeom,
      this.fotoProfil,
      this.namaPengguna,
      required this.nik,
      this.pendidikanTerakhir,
      this.pernahIkutTahun,
      required this.statusPernikahan,
      this.tanggalLahir,
      required this.email});

  final String alamat;
  final AlamatGeom? alamatGeom;
  final String? fotoProfil;
  final String? namaPengguna;
  // dynamic namaPengguna;
  final String nik;
  final String? pendidikanTerakhir;
  final String email;
  // dynamic pernahIkutTahun;
  final int? pernahIkutTahun;
  final bool statusPernikahan;
  final DateTime? tanggalLahir;

  // factory UserData.fromJson(Map<String, dynamic> json) => UserData(
  //       alamat: json["alamat"],
  //       alamatGeom: json["alamat_geom"] != null
  //           ? AlamatGeom.fromJson(json["alamat_geom"])
  //           : null,
  //       fotoProfil: json["foto_profil"],
  //       namaPengguna: json["nama_pengguna"],
  //       nik: json["nik"],
  //       email: json["user_email"],
  //       pendidikanTerakhir: json["pendidikan_terakhir"],
  //       pernahIkutTahun: json["pernah_ikut_tahun"],
  //       statusPernikahan: json["status_pernikahan"],
  //       tanggalLahir: json["tanggal_lahir"] != null
  //           ? DateTime.parse(json["tanggal_lahir"])
  //           : null,
  //     );

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      alamat: json["alamat"] ?? '',
      alamatGeom: json["alamat_geom"] != null
          ? AlamatGeom.fromJson(json["alamat_geom"])
          : null,
      fotoProfil: json["foto_profil"] ?? '',
      namaPengguna: json["nama_pengguna"] ?? '',
      nik: json["nik"] ?? '',
      email: json["user_email"] ?? '',
      pendidikanTerakhir: json["pendidikan_terakhir"] ?? '',
      pernahIkutTahun: json["pernah_ikut_tahun"] as int?,
      statusPernikahan: json["status_pernikahan"] ?? false,
      tanggalLahir: json["tanggal_lahir"] != null
          ? DateTime.parse(json["tanggal_lahir"])
          : null,
    );
  }
}

class AlamatGeom {
  AlamatGeom({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory AlamatGeom.fromJson(Map<String, dynamic> json) => AlamatGeom(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserData>((ref) {
  return UserDataNotifier();
});

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier()
      : super(UserData(
            alamat: '',
            alamatGeom: null,
            fotoProfil: '',
            nik: '',
            pendidikanTerakhir: '',
            tanggalLahir: null,
            email: '',
            statusPernikahan: false));

  // UserDataNotifier() : super(_initialUserData);

  static final _initialUserData = UserData(
    alamat: '',
    alamatGeom: null,
    fotoProfil: '',
    nik: '',
    pendidikanTerakhir: '',
    statusPernikahan: false,
    tanggalLahir: null,
    email: '',
  );

  Future<void> setUserData(
      Map<String, dynamic> userData, HasuraConnect hasuraConnect) async {
    const String docMutation = """
mutation MyMutation(\$data: user_profile_set_input) {
  update_user_profile(where: {}, _set: \$data) {
    returning {
      alamat
      alamat_geom
      foto_profil
      nama_pengguna
      nik
      pendidikan_terakhir
      pernah_ikut_tahun
      status_pernikahan
      tanggal_lahir
    }
  }
}
""";

    final response = await hasuraConnect
        .mutation(docMutation, variables: {'data': userData});

    final responseData = response['data'];

    if (responseData != null) {
      final List<dynamic> returningList =
          responseData['update_user_profile']['returning'];
      // if (returningList != null && returningList.isNotEmpty) {
      //   state = UserData.fromJson(returningList[0]);
      // }
      if (returningList.isNotEmpty) {
        state = UserData.fromJson(returningList[0]);
      }
    }

    state =
        UserData.fromJson(responseData['update_user_profile']['returning'][0]);
  }

  Future<void> uploadProfile(File file, HasuraConnect hasuraConnect) async {
    final String docMutation = """
mutation MyMutation {
  uploadProfilePic(encodedImg: "${base64Encode(file.readAsBytesSync())}", mimeType: "${lookupMimeType(file.path)}") {
    message
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);

    final responseData = response['data'];

    // print(responseData);
    final Logger logger = Logger();
    logger.d(responseData);
  }

  Future<void> getUserData(HasuraConnect hasuraConnect) async {
    const String query = """
query MyQuery {
  user_profile {
    alamat
    alamat_geom
    foto_profil
    nama_pengguna
    nik
    pendidikan_terakhir
    pernah_ikut_tahun
    status_pernikahan
    tanggal_lahir
  }
  user_auth {
    user_email
  }
}
""";

    final response = await hasuraConnect.query(query);

    final responseData = response['data'];

    if (responseData != null) {
      final List<dynamic> userProfileList = responseData['user_profile'];
      // if (userProfileList != null && userProfileList.isNotEmpty) {
      //   final Map<String, dynamic> userData = userProfileList[0];
      //   userData['user_email'] = responseData['user_auth'][0]['user_email'];

      //   print(userData);

      //   state = UserData.fromJson(userData);
      // }
      if (userProfileList.isNotEmpty) {
        final Map<String, dynamic> userData = userProfileList[0];
        userData['user_email'] = responseData['user_auth'][0]['user_email'];

        // print(userData);
        final Logger logger = Logger();
        logger.d(userData);

        state = UserData.fromJson(userData);
      }
    }

    final Map<String, dynamic> userData = responseData['user_profile'][0];
    userData['user_email'] = responseData['user_auth'][0]['user_email'];

    // print(userData);
    final Logger logger = Logger();
    logger.d(userData);

    state = UserData.fromJson(userData);
  }

  void resetUserData() {
    // state = UserData(
    //     alamat: '',
    //     alamatGeom: null,
    //     fotoProfil: '',
    //     nik: '',
    //     pendidikanTerakhir: '',
    //     statusPernikahan: null,
    //     tanggalLahir: null,
    //     email: '');
    state = _initialUserData;
  }
}
