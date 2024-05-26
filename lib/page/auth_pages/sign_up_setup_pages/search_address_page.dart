import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/page/auth_pages/sign_up_setup_pages/select_location_page.dart';
import 'package:sekopercinta_master/utils/constants.dart';
import 'package:sekopercinta_master/utils/page_transition_builder.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class SearchAddressPage extends HookWidget {
  const SearchAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchTextEditingController = useTextEditingController();
    final locations = useState<List<Address>>([]);
    final isLoading = useState(false);

    final searchLocation = useMemoized(
        () => (String address) async {
              try {
                isLoading.value = true;

                // var addresses =
                //     await Geocoder.local.findAddressesFromQuery(address);

                //   if (addresses.isEmpty) {
                //     _locations.value = [];
                //     return;
                //   }
                //   _locations.value = addresses;
              } catch (error) {
                locations.value = [];
              }

              isLoading.value = false;
            },
        []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PopAppBar(
              title: 'Cari Alamat',
              isBackIcon: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      cursorColor: Colors.black,
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: primaryGrey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: accentColor, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 12, bottom: 5, top: 5, right: 12),
                        hintText: 'Cari Alamat',
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        searchLocation(value);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      onTap: () async {
                        var address = await Navigator.of(context).push(
                          createRoute(page: const SelectLocationPage()),
                        );

                        if (address == null) {
                          return;
                        }

                        Navigator.of(context).pop(address);
                      },
                      leading: const Icon(
                        Icons.map_outlined,
                        color: primaryBlack,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: primaryBlack,
                      ),
                      title: Text(
                        'Cari pada peta',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    // _landLocation.state = LatLng(
                                    //   _locations
                                    //       .value[index].coordinates.latitude,
                                    //   _locations
                                    //       .value[index].coordinates.longitude,
                                    // );
                                    //
                                    // _addressLocation.state =
                                    //     _locations.value[index].addressLine;

                                    Navigator.of(context)
                                        .pop(locations.value[index]);
                                  },
                                  leading: const SizedBox(
                                    height: 40,
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      color: accentColor,
                                    ),
                                  ),
                                  // title: Text(
                                  //   _locations.value[index].thoroughfare,
                                  //   style:
                                  //       Theme.of(context).textTheme.subtitle1,
                                  // ),
                                  //   subtitle: Text(
                                  //     _locations.value[index].addressLine,
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: TextStyle(
                                  //       color: primaryBlack,
                                  //       fontSize: 10,
                                  //     ),
                                  //   ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: locations.value.length,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
