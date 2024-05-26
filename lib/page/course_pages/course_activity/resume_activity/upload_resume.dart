import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sekopercinta_master/providers/questions.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class UploadResumeComponents extends StatelessWidget {
  final List<Pertanyaan> question;
  final List<String> answer;

  const UploadResumeComponents({
    super.key,
    required this.answer,
    required this.question,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Aktivitas Anda',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Foto Anda akan dibagikan di halaman komunitas Sekoper Cinta!',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 16,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(answer[0]),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jawaban Anda',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: accentColor,
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                answer[1],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
