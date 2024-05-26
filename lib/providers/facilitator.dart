import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Facilitator {
  Facilitator({
    required this.namaLengkap,
    required this.namaWilayah,
    required this.nomorKontak,
    required this.urlFoto,
  });

  String namaLengkap;
  String namaWilayah;
  String nomorKontak;
  String urlFoto;

  factory Facilitator.fromJson(Map<String, dynamic> json) => Facilitator(
        namaLengkap: json["nama_lengkap"],
        namaWilayah: json["nama_wilayah"],
        nomorKontak: json["nomor_kontak"],
        urlFoto: json["url_foto"],
      );
}

final facilitatorProvider =
    StateNotifierProvider<FacilitatorNotifier, List<Facilitator>>((ref) {
  return FacilitatorNotifier();
});

class FacilitatorNotifier extends StateNotifier<List<Facilitator>> {
  FacilitatorNotifier() : super([]);

  Future<void> getFacilitator(HasuraConnect hasuraConnect) async {
    String docQuery = """
query MyQuery {
  get_user_facilitator {
    nama_lengkap
    nama_wilayah
    nomor_kontak
    url_foto
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    List<Facilitator> loadedData = [];

    for (var element
        in (responseData['get_user_facilitator'] as List<dynamic>)) {
      loadedData.add(Facilitator.fromJson(element));
    }

    state = loadedData;
  }
}
