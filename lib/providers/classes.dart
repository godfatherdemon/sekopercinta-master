import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sekopercinta_master/providers/lessons.dart';

class Kelas {
  Kelas({
    required this.namaKelas,
    required this.pelajarans,
    required this.modul,
    required this.partisipanKelasAggregate,
    required this.progresKelas,
  });

  String namaKelas;
  List<Pelajaran> pelajarans;
  Modul modul;
  PartisipanKelasAggregate partisipanKelasAggregate;
  List<dynamic> progresKelas;

  factory Kelas.fromJson(Map<String, dynamic> json) => Kelas(
        namaKelas: json["nama_kelas"],
        pelajarans: List<Pelajaran>.from(
            json["pelajarans"].map((x) => Pelajaran.fromJson(x))),
        modul: Modul.fromJson(json["modul"]),
        partisipanKelasAggregate: PartisipanKelasAggregate.fromJson(
          json["partisipan_kelas_aggregate"],
        ),
        progresKelas: List<dynamic>.from(json["progres_kelas"].map((x) => x)),
      );
}

class PartisipanKelasAggregate {
  PartisipanKelasAggregate({
    required this.aggregate,
  });

  Aggregate aggregate;

  factory PartisipanKelasAggregate.fromJson(Map<String, dynamic> json) =>
      PartisipanKelasAggregate(
        aggregate: Aggregate.fromJson(json["aggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "aggregate": aggregate.toJson(),
      };
}

class Aggregate {
  Aggregate({
    required this.count,
  });

  int count;

  factory Aggregate.fromJson(Map<String, dynamic> json) => Aggregate(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class Modul {
  Modul({
    required this.namaModul,
  });

  String namaModul;

  factory Modul.fromJson(Map<String, dynamic> json) => Modul(
        namaModul: json["nama_modul"],
      );
}

final classProvider = StateNotifierProvider<ClassNotifier, List<Kelas>>((ref) {
  return ClassNotifier(ref.watch(moduleProvider).state);
});

final changeTabIndexProvider = StateProvider<Function>((ref) {
  return () {};
});

final moduleProvider = StateProvider<String>((ref) {
  return 'Dasar';
});

final classWatcher = Provider<List<Kelas>>((ref) {
  // print('=====> something change');
  final Logger logger = Logger();
  logger.d('=====> something change');
  return ref.watch(classProvider);
});

class ClassNotifier extends StateNotifier<List<Kelas>> {
  ClassNotifier(this.module) : super([]);

  final String module;

  Future<void> getClasses(HasuraConnect hasuraConnect) async {
    // print('current module -----> $module');
    final Logger logger = Logger();
    logger.d('current module -----> $module');

    String query = """
query MyQuery {
  kelas(where: {modul: {nama_modul: {_eq: "$module"}}}, order_by: {urutan_kelas: asc}) {
    nama_kelas
    pelajarans {
      id_pelajaran
      logo_pelajaran
      nama_pelajaran
      progres_pelajarans {
        selesai
      }
    }
    modul {
      nama_modul
    }
    partisipan_kelas_aggregate {
      aggregate {
        count
      }
    }
    progres_kelas {
      selesai
    }
  }
}
""";

    final response = await hasuraConnect.query(query);
    final responseData = response['data'];

    // print(responseData);
    logger.d('PRINT $responseData');

    final List<Kelas> loadedData = [];

    for (var element in (responseData['kelas'] as List<dynamic>)) {
      loadedData.add(Kelas.fromJson(element));
    }

    state = loadedData;
  }

  Future<void> updateProgressLesson(
      HasuraConnect hasuraConnect, String id) async {
    String doc = """
mutation MyMutation {
  insert_progres_pelajaran(objects: {selesai: true, id_pelajaran: "$id"}, on_conflict: {constraint: progres_pelajaran_pkey, update_columns: selesai}) {
    affected_rows
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    // print('update pelajar progres =====> $responseData');
    final Logger logger = Logger();
    logger.d('update pelajar progres =====> $responseData');

    await getClasses(hasuraConnect);
  }

  Future<void> updateProgressClass(
      HasuraConnect hasuraConnect, String id) async {
    String doc = """
mutation MyMutation {
  insert_progres_kelas(objects: {selesai: true, id_kelas: "$id"}, on_conflict: {constraint: progres_kelas_pkey, update_columns: selesai}) {
    affected_rows
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    // print('update kelas progres =====> $responseData');
    final Logger logger = Logger();
    logger.d('update kelas progres =====> $responseData');

    await getClasses(hasuraConnect);
  }
}
