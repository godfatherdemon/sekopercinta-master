import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Lampiran {
  Lampiran({
    required this.idLampiran,
    required this.namaLampiran,
    required this.jenisLampiran,
    required this.url,
  });

  String idLampiran;
  String namaLampiran;
  String jenisLampiran;
  String url;

  factory Lampiran.fromJson(Map<String, dynamic> json) => Lampiran(
        idLampiran: json["id_lampiran"],
        namaLampiran: json["nama_lampiran"],
        jenisLampiran: json["jenis_lampiran"],
        url: json["url"],
      );
}

final attachmentProvider =
    StateNotifierProvider<AttachmentsNotifier, List<Lampiran>>((ref) {
  return AttachmentsNotifier();
});

class AttachmentsNotifier extends StateNotifier<List<Lampiran>> {
  AttachmentsNotifier() : super([]);

  Future<void> getAttachments(String id, HasuraConnect hasuraConnect) async {
    String docQuery = """
query MyQuery {
  lampiran_pelajaran(where: {id_pelajaran: {_eq: "$id"}}) {
    id_lampiran
    jenis_lampiran
    nama_lampiran
    url
  }
}

""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    List<Lampiran> loadedData = [];

    (responseData['lampiran_pelajaran'] as List<dynamic>).forEach((element) {
      loadedData.add(Lampiran.fromJson(element));
    });

    state = loadedData;
  }
}
