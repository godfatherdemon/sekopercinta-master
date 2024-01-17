import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:sekopercinta/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta/page/auth_pages/sign_up_setup_pages/select_location_page.dart';
import 'package:sekopercinta/utils/constants.dart';
import 'package:sekopercinta/utils/page_transition_builder.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class SearchAddressPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _searchTextEditingController = useTextEditingController();
    final _locations = useState<List<Address>>([]);
    final _isLoading = useState(false);

    final _searchLocation = useMemoized(
        () => (String address) async {
              try {
                _isLoading.value = true;

                // var addresses =
                //     await Geocoder.local.findAddressesFromQuery(address);

                //   if (addresses.isEmpty) {
                //     _locations.value = [];
                //     return;
                //   }
                //   _locations.value = addresses;
              } catch (error) {
                _locations.value = [];
              }

              _isLoading.value = false;
            },
        []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PopAppBar(
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
                      controller: _searchTextEditingController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryGrey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: accentColor, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: 12, bottom: 5, top: 5, right: 12),
                        hintText: 'Cari Alamat',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        _searchLocation(value);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      onTap: () async {
                        var address = await Navigator.of(context).push(
                          createRoute(page: SelectLocationPage()),
                        );

                        if (address == null) {
                          return;
                        }

                        Navigator.of(context).pop(address);
                      },
                      leading: Icon(
                        Icons.map_outlined,
                        color: primaryBlack,
                      ),
                      trailing: Icon(
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
                      child: _isLoading.value
                          ? Center(child: CircularProgressIndicator())
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
                                        .pop(_locations.value[index]);
                                  },
                                  leading: Container(
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
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: _locations.value.length,
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
