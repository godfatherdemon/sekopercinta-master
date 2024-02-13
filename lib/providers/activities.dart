import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:sekopercinta_master/providers/classes.dart';

import 'lessons.dart';

class Aktivitas {
  Aktivitas({
    required this.idAktivitas,
    required this.jenisAktivitas,
    required this.namaAktivitas,
    required this.sumberAktivitas,
    required this.progresAktivitas,
    required this.isInLastLesson,
  });

  String idAktivitas;
  String jenisAktivitas;
  String namaAktivitas;
  List<SumberAktivita> sumberAktivitas;
  List<ProgresAktivita> progresAktivitas;
  bool isInLastLesson;

  factory Aktivitas.fromJson(Map<String, dynamic> json) => Aktivitas(
      idAktivitas: json["id_aktivitas"],
      jenisAktivitas: json["jenis_aktivitas"],
      namaAktivitas: json["nama_aktivitas"],
      sumberAktivitas: List<SumberAktivita>.from(
          json["sumber_aktivitas"].map((x) => SumberAktivita.fromJson(x))),
      progresAktivitas: List<ProgresAktivita>.from(
          json["progres_aktivitas"].map((x) => ProgresAktivita.fromJson(x))),
      isInLastLesson: json['is_in_last_lesson']);
}

class ProgresAktivita {
  ProgresAktivita({
    required this.progres,
  });

  double progres;

  factory ProgresAktivita.fromJson(Map<String, dynamic> json) =>
      ProgresAktivita(
        progres: json["progres"].toDouble(),
      );
}

class SumberAktivita {
  SumberAktivita({
    required this.durasiKonten,
  });

  String durasiKonten;

  factory SumberAktivita.fromJson(Map<String, dynamic> json) => SumberAktivita(
        durasiKonten: json["durasi_konten"],
      );
}

final activityProvider =
    StateNotifierProvider<ActivityNotifier, List<Aktivitas>>((ref) {
  return ActivityNotifier(ref.watch(lessonProvider));
});

class ActivityNotifier extends StateNotifier<List<Aktivitas>> {
  // ActivityNotifier(Pelajaran pelajaran)
  //     : super(pelajaran.aktivitas != null ? [...pelajaran.aktivitas] : []);
  ActivityNotifier(Pelajaran pelajaran) : super([...pelajaran.aktivitas]);

  Future<String> getActivityContent(
      HasuraConnect hasuraConnect, String activityId) async {
    String docQuery = """
query MyQuery {
  sumber_aktivitas_by_pk(id_aktivitas: "$activityId") {
    konten
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    return responseData['sumber_aktivitas_by_pk']['konten'];
  }

  Future<Map<String, dynamic>> getActivityIntroduction(
      HasuraConnect hasuraConnect, String activityId) async {
    String docQuery = """
query MyQuery {
  pengantar_aktivitas_by_pk(id_aktivitas: "$activityId") {
    isi_pengantar
    aktivitas {
      pertanyaan_kuis {
        isi_pertanyaan
      }
    }
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    return {
      'isi_pengantar': responseData['pengantar_aktivitas_by_pk']
          ['isi_pengantar'],
      'total': (responseData['pengantar_aktivitas_by_pk']['aktivitas']
              ['pertanyaan_kuis'] as List<dynamic>)
          .length
    };
  }

  Future<Map<String, dynamic>> getActivityResume(
      HasuraConnect hasuraConnect, String activityId) async {
    String docQuery = """
query MyQuery {
  resume_aktivitas_by_pk(id_aktivitas: "$activityId") {
    judul_resume
    pengantar_ke_lampiran
    isi_resume
  }
}
""";

    final response = await hasuraConnect.query(docQuery);
    final responseData = response['data'];

    print(responseData);

    return responseData['resume_aktivitas_by_pk'];
  }

  Future<void> updateProgress(BuildContext context, HasuraConnect hasuraConnect,
      String id, double progress) async {
    var isLast = false;

    if (state.last.idAktivitas == id) {
      final Pelajaran lesson = context.read(lessonProvider);

      final classState = context.read(classProvider.notifier);

      print(
          '==================> ini aktivitas terakhir di pelajaran ${lesson.idPelajaran}');

      await classState.updateProgressLesson(hasuraConnect, lesson.idPelajaran);

      if (state
          .where((element) => id == element.idAktivitas)
          .first
          .isInLastLesson) {
        print(
            '==================> ini aktivitas di lesson terakhir di kelas ${lesson.idKelas}');

        isLast = true;

        await classState.updateProgressClass(hasuraConnect, lesson.idKelas);
      }
    }

    if (progress > 0.85) {
      progress = 1.0;
    }

    String doc = """
mutation MyMutation {
  insert_progres_aktivitas_one(object: {id_aktivitas: "$id", progres: $progress}, on_conflict: {constraint: progres_aktivitas_pkey, update_columns: progres}) {
    progres
    aktivitas {
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
  }
}
""";

    final response = await hasuraConnect.mutation(doc);
    final responseData = response['data'];

    print(responseData);

    responseData['insert_progres_aktivitas_one']['aktivitas']
        ['is_in_last_lesson'] = isLast;

    final updatedActivity = Aktivitas.fromJson(
        responseData['insert_progres_aktivitas_one']['aktivitas']);
    final List<Aktivitas> activities = [];

    for (int i = 0; i < state.length; i++) {
      if (state[i].idAktivitas == updatedActivity.idAktivitas) {
        activities.add(updatedActivity);
      } else {
        activities.add(state[i]);
      }
    }

    state = activities;
  }

  Future<void> sendActivityCommunityImage(
      {required File file,
      required HasuraConnect hasuraConnect,
      required String id,
      required String comment}) async {
    final String docMutation = """
mutation MyMutation {
  uploadCommunityPost(activityId: "$id", encodedImg: "${base64Encode(file.readAsBytesSync())}", mimeType: "${lookupMimeType(file.path)}", comment: "$comment") {
    message
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);

    final responseData = response['data'];

    print('SEND COMPLETE $responseData');
  }

  Future<void> sendCommunityImage(
      {required File file,
      required HasuraConnect hasuraConnect,
      required String comment}) async {
    final String docMutation = """
mutation MyMutation {
  uploadCommunityPost(encodedImg: "${base64Encode(file.readAsBytesSync())}", mimeType: "${lookupMimeType(file.path)}", comment: "$comment") {
    message
  }
}
""";

    final response = await hasuraConnect.mutation(docMutation);

    final responseData = response['data'];

    print('SEND COMPLETE $responseData');
  }
}
