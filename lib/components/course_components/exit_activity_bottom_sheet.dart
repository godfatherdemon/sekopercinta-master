import 'package:flutter/material.dart';
import 'package:sekopercinta_master/components/custom_button/fill_button.dart';
import 'package:sekopercinta_master/utils/constants.dart';

class ExitActivityBottomSheet extends StatelessWidget {
  final String activityName;

  const ExitActivityBottomSheet(this.activityName, {super.key});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Keluar Aktivitas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryVeryDarkColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Apakah Anda yakin akan keluar dari aktivitas “$activityName” ?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFA2A1A1),
                    ),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Expanded(
                    child: FillButton(
                      text: 'Ya',
                      color: brokenWhite,
                      textColor: primaryBlack,
                      onTap: () => Navigator.of(context).pop(true),
                      leading: Container(),
                    ),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: FillButton(
                      text: 'Tidak',
                      onTap: () => Navigator.of(context).pop(false),
                      leading: Container(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
