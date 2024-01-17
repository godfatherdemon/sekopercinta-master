import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sekopercinta/components/custom_button/fill_button.dart';
import 'package:sekopercinta/components/shimmer_componenet/shimmer_card.dart';
import 'package:sekopercinta/providers/facilitator.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sekopercinta/utils/hasura_config.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilitatorBottomSheet extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _isLoading = useState(false);
    final _facilitator = useState(context.read(facilitatorProvider));

    useEffect(() {
      if (_facilitator.value.isEmpty) {
        _isLoading.value = true;
      }
      print('load');
      context
          .read(facilitatorProvider.notifier)
          .getFacilitator(context.read(hasuraClientProvider).state)
          .then((_) {
        _isLoading.value = false;
        _facilitator.value = context.read(facilitatorProvider);
      });

      return;
    }, []);
    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () => Navigator.of(context).pop(),
          child: const SizedBox(
            height: 100,
            width: double.infinity,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 4,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _facilitator.value.isNotEmpty
                          ? SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 12.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 12.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Fasilitator Anda',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: primaryVeryDarkColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Chat bersama Fasilitator regional Anda',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: Color(0xFFA2A1A1),
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          _facilitator.value[0].namaLengkap ==
                                                  null
                                              ? ShimmerCard(
                                                  height: 70,
                                                  width: double.infinity,
                                                  borderRadius: 12)
                                              : Card(
                                                  elevation: 8,
                                                  shadowColor: primaryColor
                                                      .withOpacity(0.1),
                                                  margin:
                                                      const EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      children: [
                                                        _facilitator.value[0]
                                                                    .urlFoto ==
                                                                null
                                                            ? Container(
                                                                width: 56,
                                                                height: 56,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/img-women-a.png',
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child: Image
                                                                    .network(
                                                                  _facilitator
                                                                      .value[0]
                                                                      .urlFoto,
                                                                  width: 56,
                                                                  height: 56,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _facilitator
                                                                    .value[0]
                                                                    .namaLengkap,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                      color:
                                                                          primaryVeryDarkColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                'Fasilitator daerah ${_facilitator.value[0].namaWilayah}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                      color: Color(
                                                                          0xFFA2A1A1),
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Kapan Anda dapat menghubungi fasilitator?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/images/ic-check.png',
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Memerlukan bantuan teknis penggunaan Aplikasi',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/images/ic-check.png',
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Telah menyelesaikan seluruh Modul Dasar dan Tematik dan ingin membuat Sertifikasi',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/images/ic-check.png',
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Ingin menanyakan informasi terkait modul yang telah Anda pelajari',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Ketentuan menghubungi fasilitator',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: primaryDarkColor,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  'Fasilitas ini dapat anda gunakan untuk memperoleh bantuan terkait aplikasi Sekoper Cinta, harap menghubungi fasilitator pada jam operasional yaitu pada puku 09:00 - 15:00 WIB',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: primaryDarkColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          FillButton(
                                            text: 'Hubungi Sekarang',
                                            onTap: () {
                                              launchUrl(
                                                  "tel:${_facilitator.value[0].nomorKontak}"
                                                      as Uri);
                                            },
                                            leading: Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/ic-empty-discussion.png',
                                      width: 112,
                                    ),
                                    const SizedBox(
                                      height: 21,
                                    ),
                                    Text(
                                      'Belum Tersedia',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Fasilitator untuk di daerah Anda belum tersedia',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
