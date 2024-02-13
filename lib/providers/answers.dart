import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Answer {
  Answer({
    required this.tampilanJawaban,
    required this.isiJawaban,
  });

  String tampilanJawaban;
  String isiJawaban;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        tampilanJawaban: json["tampilan_jawaban"],
        isiJawaban: json["isi_jawaban"],
      );
}

final answersProvider =
    StateNotifierProvider<AnswersNotifier, List<Answer>>((ref) {
  return AnswersNotifier();
});

class AnswersNotifier extends StateNotifier<List<Answer>> {
  AnswersNotifier() : super([]);

  Future<void> getAnswers(HasuraConnect hasuraConnect, String id) async {
    print(id);

    String docQuery = """
query MyQuery {
  pilihan_jawaban_pilgan(where: {id_aktivitas: {_eq: "$id"}}) {
    tampilan_jawaban
    isi_jawaban
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    List<Answer> loadedData = [];

    (responseData['pilihan_jawaban_pilgan'] as List<dynamic>)
        .forEach((element) {
      loadedData.add(Answer.fromJson(element));
    });

    state = loadedData;
  }
}
