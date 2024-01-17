import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Diskusi {
  Diskusi({
    required this.idDiskusi,
    required this.isiDiskusi,
    required this.dikirimPada,
    required this.profilPublik,
    required this.balasanDiskusiPelajarans,
  });

  String idDiskusi;
  String isiDiskusi;
  DateTime dikirimPada;
  ProfilPublik profilPublik;
  List<BalasanDiskusiPelajaran> balasanDiskusiPelajarans;

  factory Diskusi.fromJson(Map<String, dynamic> json) => Diskusi(
        idDiskusi: json["id_diskusi"],
        isiDiskusi: json["isi_diskusi"],
        dikirimPada: DateTime.parse(json["dikirim_pada"]),
        profilPublik: ProfilPublik.fromJson(json["profil_publik"]),
        balasanDiskusiPelajarans: List<BalasanDiskusiPelajaran>.from(
            json["balasan_diskusi_pelajarans"]
                .map((x) => BalasanDiskusiPelajaran.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_diskusi": idDiskusi,
        "isi_diskusi": isiDiskusi,
        "dikirim_pada": dikirimPada.toIso8601String(),
        "profil_publik": profilPublik.toJson(),
        "balasan_diskusi_pelajarans":
            List<dynamic>.from(balasanDiskusiPelajarans.map((x) => x.toJson())),
      };
}

class BalasanDiskusiPelajaran {
  BalasanDiskusiPelajaran({
    required this.dikirimPada,
    required this.idBalasan,
    required this.isiBalasan,
  });

  DateTime dikirimPada;
  String idBalasan;
  String isiBalasan;

  factory BalasanDiskusiPelajaran.fromJson(Map<String, dynamic> json) =>
      BalasanDiskusiPelajaran(
        dikirimPada: DateTime.parse(json["dikirim_pada"]),
        idBalasan: json["id_balasan"],
        isiBalasan: json["isi_balasan"],
      );

  Map<String, dynamic> toJson() => {
        "dikirim_pada": dikirimPada.toIso8601String(),
        "id_balasan": idBalasan,
        "isi_balasan": isiBalasan,
      };
}

class ProfilPublik {
  ProfilPublik({
    this.namaPengguna,
    required this.fotoProfil,
  });

  dynamic namaPengguna;
  String fotoProfil;

  factory ProfilPublik.fromJson(Map<String, dynamic> json) => ProfilPublik(
        namaPengguna: json["nama_pengguna"],
        fotoProfil: json["foto_profil"],
      );

  Map<String, dynamic> toJson() => {
        "nama_pengguna": namaPengguna,
        "foto_profil": fotoProfil,
      };
}

final discussionsProvider =
    StateNotifierProvider<DiscussionsNotifier, List<Diskusi>>((ref) {
  return DiscussionsNotifier();
});

class DiscussionsNotifier extends StateNotifier<List<Diskusi>> {
  DiscussionsNotifier() : super([]);

  Future<void> getDiscussions(String id, HasuraConnect hasuraConnect) async {
    String docQuery = """
query MyQuery {
  diskusi_pelajaran(where: {id_pelajaran: {_eq: "$id"}}) {
    id_diskusi
    isi_diskusi
    dikirim_pada
    profil_publik {
      nama_pengguna
      foto_profil
    }
    balasan_diskusi_pelajarans {
      dikirim_pada
      id_balasan
      isi_balasan
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    List<Diskusi> loadedData = [];

    (responseData['diskusi_pelajaran'] as List<dynamic>).forEach((element) {
      loadedData.add(Diskusi.fromJson(element));
    });

    state = loadedData;
  }
}
