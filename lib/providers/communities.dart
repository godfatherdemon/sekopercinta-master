// import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class Komunitas {
  Komunitas({
    required this.dikirimPada,
    required this.foto,
    required this.funnyCount,
    required this.idKiriman,
    required this.komentar,
    required this.likeCount,
    required this.superCount,
    required this.wowCount,
    required this.responsKomunitas,
    required this.profilPublik,
  });

  DateTime dikirimPada;
  String foto;
  int funnyCount;
  String idKiriman;
  String komentar;
  int likeCount;
  int superCount;
  int wowCount;
  List<ResponsKomunita> responsKomunitas;
  ProfilPublik profilPublik;

  factory Komunitas.fromJson(Map<String, dynamic> json) => Komunitas(
        dikirimPada: DateTime.parse(json["dikirim_pada"]),
        foto: json["foto"],
        funnyCount: json["funny_count"],
        idKiriman: json["id_kiriman"],
        komentar: json["komentar"],
        likeCount: json["like_count"],
        superCount: json["super_count"],
        wowCount: json["wow_count"],
        responsKomunitas: List<ResponsKomunita>.from(
            json["respons_komunitas"].map((x) => ResponsKomunita.fromJson(x))),
        profilPublik: ProfilPublik.fromJson(json["profil_publik"]),
      );
}

class ProfilPublik {
  ProfilPublik({
    required this.namaPengguna,
    required this.fotoProfil,
  });

  String namaPengguna;
  String fotoProfil;

  factory ProfilPublik.fromJson(Map<String, dynamic> json) => ProfilPublik(
        namaPengguna: json["nama_pengguna"],
        fotoProfil: json["foto_profil"],
      );
}

class ResponsKomunita {
  ResponsKomunita({
    required this.respons,
  });

  String respons;

  factory ResponsKomunita.fromJson(Map<String, dynamic> json) =>
      ResponsKomunita(
        respons: json["respons"],
      );
}

final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, List<Komunitas>>((ref) {
  return CommunitiesNotifier();
});

final myCommunityProvider =
    StateNotifierProvider<MyCommunityNotifier, List<Komunitas>>((ref) {
  return MyCommunityNotifier();
});

class MyCommunityNotifier extends StateNotifier<List<Komunitas>> {
  MyCommunityNotifier() : super([]);

  Future<void> getMyCommunities(HasuraConnect hasuraConnect) async {
    String docQuery = """
query MyQuery {
  komunitas_saya {
    dikirim_pada
    foto
    funny_count
    id_kiriman
    komentar
    like_count
    super_count
    wow_count
    respons_komunitas {
      respons
    }
    profil_publik {
      nama_pengguna
      foto_profil
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    // print('PRINT $responseData');
    final Logger logger = Logger();
    logger.d('PRINT $responseData');

    List<Komunitas> loadedData = [];

    for (var element in (responseData['komunitas_saya'] as List<dynamic>)) {
      loadedData.add(Komunitas.fromJson(element));
    }

    state = loadedData;
  }
}

class CommunitiesNotifier extends StateNotifier<List<Komunitas>> {
  CommunitiesNotifier() : super([]);

  Future<void> getCommunities(HasuraConnect hasuraConnect) async {
    String docQuery = """
query MyQuery {
  komunitas(order_by: {dikirim_pada: desc}, offset: 0, limit: 10) {
    dikirim_pada
    foto
    funny_count
    id_kiriman
    komentar
    like_count
    super_count
    wow_count
    respons_komunitas {
      respons
    }
    profil_publik {
      nama_pengguna
      foto_profil
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    // print(responseData);
    final Logger logger = Logger();
    logger.d('PRINT $responseData');

    List<Komunitas> loadedData = [];

    for (var element in (responseData['komunitas'] as List<dynamic>)) {
      loadedData.add(Komunitas.fromJson(element));
    }

    state = loadedData;
  }

  Future<void> giveResponse(
      {required String id,
      required String likeResponse,
      required bool isUpdate,
      required HasuraConnect hasuraConnect}) async {
    String doc = isUpdate
        ? """
mutation MyMutation {
  update_respons_komunitas(where: {id_kiriman: {_eq: "$id"}}, _set: {respons: "$likeResponse"}) {
    affected_rows
  }
}
"""
        : """
mutation MyMutation {
  insert_respons_komunitas_one(object: {id_kiriman: "$id", respons: "$likeResponse"}) {
    respons
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    // print(responseData);
    final Logger logger = Logger();
    logger.d('PRINT $responseData');
  }
}
