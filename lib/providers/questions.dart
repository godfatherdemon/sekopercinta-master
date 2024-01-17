// import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sekopercinta/providers/answers.dart';

class Pertanyaan {
  Pertanyaan({
    required this.isiPertanyaan,
    required this.idPertanyaan,
    required this.kunciJawabanPilgans,
    required this.pilihanJawaban,
  });

  String isiPertanyaan;
  String idPertanyaan;
  List<KunciJawabanPilgan> kunciJawabanPilgans;
  List<Answer> pilihanJawaban;

  factory Pertanyaan.fromJson(Map<String, dynamic> json) => Pertanyaan(
        isiPertanyaan: json["isi_pertanyaan"],
        idPertanyaan: json["id_pertanyaan"],
        kunciJawabanPilgans: List<KunciJawabanPilgan>.from(
            json["kunci_jawaban_pilgans"]
                .map((x) => KunciJawabanPilgan.fromJson(x))),
        pilihanJawaban: json["pilihan_jawaban_pilgan_banyaks"] != null
            ? List<Answer>.from(json["pilihan_jawaban_pilgan_banyaks"]
                .map((x) => Answer.fromJson(x)))
            : [],
      );
}

class KunciJawabanPilgan {
  KunciJawabanPilgan({
    required this.isiJawaban,
  });

  String isiJawaban;

  factory KunciJawabanPilgan.fromJson(Map<String, dynamic> json) =>
      KunciJawabanPilgan(
        isiJawaban: json["isi_jawaban"],
      );
}

final questionProvider =
    StateNotifierProvider<QuestionNotifier, List<Pertanyaan>>((ref) {
  return QuestionNotifier();
});

class QuestionNotifier extends StateNotifier<List<Pertanyaan>> {
  QuestionNotifier() : super([]);

  Future<void> getQuestions(
      {required HasuraConnect hasuraConnect,
      required String id,
      bool isMultiChoiceMany = false}) async {
    print(id);

    String docQuery = isMultiChoiceMany
        ? """
query MyQuery {
  pertanyaan_kuis(where: {id_aktivitas: {_eq: "$id"}}, order_by: {urutan_pertanyaan: asc}) {
    isi_pertanyaan
    id_pertanyaan
    kunci_jawaban_pilgans {
      isi_jawaban
    }
    pilihan_jawaban_pilgan_banyaks {
      isi_jawaban
      tampilan_jawaban
    }
  }
}
"""
        : """
query MyQuery {
  pertanyaan_kuis(where: {id_aktivitas: {_eq: "$id"}}, order_by: {urutan_pertanyaan: asc}) {
    isi_pertanyaan
    id_pertanyaan
    kunci_jawaban_pilgans {
      isi_jawaban
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    List<Pertanyaan> loadedData = [];

    (responseData['pertanyaan_kuis'] as List<dynamic>).forEach((element) {
      loadedData.add(Pertanyaan.fromJson(element));
    });

    state = loadedData;
  }

  Future<List<dynamic>> getUploadInstruction(
      HasuraConnect hasuraConnect, String id) async {
    print(id);

    String docQuery = """
query MyQuery {
  instruksi_aktivitas_unggah(where: {id_aktivitas: {_eq: "$id"}}) {
    instruksi_komentar
    instruksi_unggah
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    return responseData['instruksi_aktivitas_unggah'];
  }

  Future<Map<String, dynamic>> getTrueFalseQuestion(
      HasuraConnect hasuraConnect, String id) async {
    print(id);

    String docQuery = """
query MyQuery {
  pernyataan_aktivitas_benarsalah_by_pk(id_aktivitas: "$id") {
    id_aktivitas
    isi_pernyataan
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData['pernyataan_aktivitas_benarsalah_by_pk']);

    return responseData['pernyataan_aktivitas_benarsalah_by_pk'];
  }

  Future<void> giveAnswerEssay(HasuraConnect hasuraConnect,
      List<Map<String, String>> objects, String id) async {
    print('JAWABAN $objects');
    String doc = """
mutation MyMutation(\$answer: [jawaban_essay_insert_input!]!) {
  insert_jawaban_essay(objects: \$answer, on_conflict: {constraint: jawaban_essay_pkey, update_columns: isi_jawaban}) {
    affected_rows
  }
}
""";

    final response =
        await hasuraConnect.mutation(doc, variables: {'answer': objects});
    final responseData = response['data'];

    print(responseData);
  }

  Future<void> giveAnswerMany(
      HasuraConnect hasuraConnect, String answer, String id) async {
    print(answer);

    String doc = """
mutation MyMutation {
  insert_jawaban_banyak_one(object: {id_pertanyaan: "$id", isi_jawaban: "$answer"}, on_conflict: {constraint: jawaban_banyak_pkey, update_columns: isi_jawaban}) {
    id_pertanyaan
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    print(responseData);
  }

  Future<void> giveAnswerMultipleChoice(HasuraConnect hasuraConnect,
      List<Map<String, String>> objects, String id) async {
    print('JAWABAN $objects');
    String doc = """
mutation MyMutation(\$answer: [jawaban_pilgan_insert_input!]!) {
  insert_jawaban_pilgan(objects: \$answer, on_conflict: {constraint: jawaban_pilgan_pkey, update_columns: isi_jawaban}) {
    affected_rows
  }
}
""";

    final response =
        await hasuraConnect.mutation(doc, variables: {'answer': objects});
    final responseData = response['data'];

    print(responseData);
  }

  Future<void> giveAnswerTrueFalse(HasuraConnect hasuraConnect,
      List<Map<String, dynamic>> objects, String id) async {
    print('JAWABAN $objects');
    String doc = """
mutation MyMutation(\$answer: [jawaban_benarsalah_insert_input!]!) {
  insert_jawaban_benarsalah(objects: \$answer, on_conflict: {constraint: jawaban_benarsalah_pkey, update_columns: isi_jawaban}) {
    affected_rows
  }
}
""";

    final response =
        await hasuraConnect.mutation(doc, variables: {'answer': objects});
    final responseData = response['data'];

    print(responseData);
  }
}
