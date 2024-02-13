import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import 'constants.dart';

Future<String> getSignedLink(
    {required File file,
    required HasuraConnect hasuraConnect,
    required String docType}) async {
  final query = """
query MyQuery {
  getSignedUrlForPut(docType: "$docType", mimeType: "${lookupMimeType(file.path)}", fileName: "${basename(file.path)}", fileSize: ${file.lengthSync()}) {
    signedUrl
  }
}    
""";

  final response = await hasuraConnect.query(query);

  return response['data']['getSignedUrlForPut']['signedUrl'];
}

Future<void> sendFile(File file, String url) async {
  await Dio().put(
    url,
    data: file.openRead(),
    options: Options(
      contentType: lookupMimeType(file.path),
      headers: {
        "Content-Length": file.lengthSync(),
      },
    ),
    onSendProgress: (int sentBytes, int totalBytes) {
      double progressPercent = sentBytes / totalBytes * 100;
      print("permit: $progressPercent %");
    },
  );
}

Future<String?> selectPhotoHandler(BuildContext context) async {
  final String action = await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unggah foto melalui',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('camera');
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/ic-camera.png',
                                  color: primaryColor,
                                  width: 24,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Kamera',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop('gallery');
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/ic-gallery.png',
                                  color: primaryColor,
                                  width: 24,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Galeri',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  // if (action != null) {
  //   return action;
  // } else {
  //   return null;
  // }
  return action;
}
