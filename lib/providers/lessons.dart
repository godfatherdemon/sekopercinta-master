import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/providers/activities.dart';

class Pelajaran {
  Pelajaran({
    required this.logoPelajaran,
    required this.namaPelajaran,
    required this.pengenalanPelajaran,
    required this.pokokBahasanPelajaran,
    required this.aktivitas,
    required this.idPelajaran,
    required this.idKelas,
    required this.progresPelajarans,
    required this.isLastLesson,
  });

  String logoPelajaran;
  String namaPelajaran;
  String pengenalanPelajaran;
  String pokokBahasanPelajaran;
  List<Aktivitas> aktivitas;
  String idPelajaran;
  String idKelas;
  List<dynamic> progresPelajarans;
  bool isLastLesson;

  factory Pelajaran.fromJson(Map<String, dynamic> json) => Pelajaran(
        logoPelajaran: json["logo_pelajaran"],
        namaPelajaran: json["nama_pelajaran"],
        pengenalanPelajaran: json["pengenalan_pelajaran"],
        pokokBahasanPelajaran: json["pokok_bahasan_pelajaran"],
        aktivitas: List<Aktivitas>.from((json["aktivitas"] ?? []).map((x) {
          x['is_in_last_lesson'] = json["is_last_lesson"];
          return Aktivitas.fromJson(x);
        })),
        idPelajaran: json["id_pelajaran"],
        idKelas: json["id_kelas"],
        progresPelajarans:
            List<dynamic>.from(json["progres_pelajarans"].map((x) => x)),
        isLastLesson: json["is_last_lesson"],
      );
}

final lessonProvider = StateNotifierProvider<LessonNotifier, Pelajaran>((ref) {
  return LessonNotifier();
});

class LessonNotifier extends StateNotifier<Pelajaran> {
  LessonNotifier()
      : super(Pelajaran(
            idPelajaran: '',
            aktivitas: [],
            logoPelajaran: '',
            pengenalanPelajaran: '',
            namaPelajaran: '',
            pokokBahasanPelajaran: '',
            idKelas: '',
            progresPelajarans: [],
            isLastLesson: false));

  Future<void> getLessons(
      HasuraConnect hasuraConnect, String id, bool isLastLessons) async {
    // print(id);
    final Logger logger = Logger();
    logger.d(id);

    String docQuery = """
query MyQuery {
  pelajaran(where: {id_pelajaran: {_eq: "$id"}}) {
    logo_pelajaran
    nama_pelajaran
    pengenalan_pelajaran
    pokok_bahasan_pelajaran
    progres_pelajarans {
      selesai
    }
    aktivitas(order_by: {urutan_aktivitas: asc}) {
      id_aktivitas
      jenis_aktivitas
      nama_aktivitas
      sumber_aktivitas {
        durasi_konten
      }
      progres_aktivitas {
        progres
      }
    }
    id_pelajaran
    id_kelas
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    // print('GET PELAJARAN $responseData');
    logger.d('GET PELAJARAN $responseData');

    responseData['pelajaran'][0]['is_last_lesson'] = isLastLessons;

    state = Pelajaran.fromJson(responseData['pelajaran'][0]);
  }

  Future<void> sendComment(HasuraConnect hasuraConnect, String comment) async {
    String doc = """
mutation MyMutation {
  insert_diskusi_pelajaran(objects: {isi_diskusi: "$comment", id_pelajaran: "${state.idPelajaran}"}) {
    affected_rows
  }
}

""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    // print(responseData);
    final Logger logger = Logger();
    logger.d(responseData);
  }
}
