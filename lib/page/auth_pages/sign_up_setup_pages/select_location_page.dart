import 'package:flutter/material.dart';
import 'package:location/location.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sekopercinta_master/components/custom_app_bar/pop_app_bar.dart';
import 'package:sekopercinta_master/components/text_field/bordered_text_field.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

const ACCESS_TOKEN =
    'pk.eyJ1IjoiYXJheWhhbiIsImEiOiJjazdoMmNpYmkwNXlwM25xa3ZzN3Rhc2p5In0.KsW5-BlR0oim5P5D0IB9sw';

class SelectLocationPage extends StatefulWidget {
  static const routeName = '/select-location-page';

  const SelectLocationPage({super.key});
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  bool _showLocation = false;
  bool _isLoading = false;
  final _searchTextEditingController = TextEditingController();
  late Address _address;

  // late MapboxMapController mapController;

  // void _onMapCreated(MapboxMapController controller) {
  //   mapController = controller;
  //   _trackUserLocation();
  // }

  Future<void> _trackUserLocation() async {
    if (await Permission.location.request().isGranted) {
      Location location = Location();

      bool serviceEnabled;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      setState(() {
        _isLoading = true;
      });

      var myLocation = await location.getLocation();
      // await mapController.animateCamera(CameraUpdate.newLatLng(
      //     LatLng(myLocation.latitude ?? 0.0, myLocation.longitude ?? 0.0)));

      if (_showLocation == false) {
        setState(() {
          _showLocation = true;
        });
      }

      //   final coordinates =
      //       Coordinates(myLocation.latitude, myLocation.longitude);

      //   List<Address> addresses =
      //       await YandexGeocoder(ACCESS_TOKEN).getAddress(coordinates);

      //   if (addresses.isEmpty) {
      //     return;
      //   }

      //   var first = addresses.first;
      //   setState(() {
      //     _address = first;
      //   });

      //   _searchTextEditingController.text = first.formatted!;
      //   setState(() {
      //     _isLoading = false;
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PopAppBar(
              title: 'Cari Alamat',
              isBackIcon: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BorderedFormField(
                hint: 'Alamat Terpilih',
                textEditingController: _searchTextEditingController,
                initialValue: '',
                focusNode: FocusNode(),
                onFieldSubmitted: (string) {},
                maxLine: 999,
                onChanged: (string) {},
                onSaved: (string) {},
                onTap: () {},
                validator: (string) {},
                suffixIcon: Container(),
              ),
            ),
            const Expanded(
              child: Stack(
                  // children: [
                  //   MapboxMap(
                  //     accessToken: ACCESS_TOKEN,
                  //     compassEnabled: false,
                  //     myLocationEnabled: _showLocation,
                  //     myLocationRenderMode: MyLocationRenderMode.COMPASS,
                  //     trackCameraPosition: true,
                  //     onMapCreated: _onMapCreated,
                  //     initialCameraPosition: const CameraPosition(
                  //       target: LatLng(-6.902374677453237, 107.6188154005428),
                  //       zoom: 15,
                  //     ),
                  //     onCameraIdle: () async {
                  //       print('IDLEEE');
                  //       setState(() {
                  //         _isLoading = true;
                  //       });

                  //       // var myLocation = mapController.cameraPosition?.target;

                  //       //   final coordinates = Coordinates(
                  //       //       myLocation?.latitude, myLocation?.longitude);

                  //       //   try {
                  //       //     List<Address> addresses =
                  //       //         await YandexGeocoder(ACCESS_TOKEN)
                  //       //             .getAddress(coordinates);

                  //       //     if (addresses.isEmpty) {
                  //       //       return;
                  //       //     }

                  //       //     var first = addresses.first;
                  //       //     setState(() {
                  //       //       _address = first;
                  //       //     });

                  //       //     _searchTextEditingController.text = first.formatted;
                  //       //   } catch (error) {
                  //       //     throw error;
                  //       //   }

                  //       //   setState(() {
                  //       //     _isLoading = false;
                  //       //   });
                  //     },
                  //   ),
                  //   Positioned(
                  //     top: 0,
                  //     right: 0,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Card(
                  //         elevation: 5,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: InkWell(
                  //           onTap: _trackUserLocation,
                  //           child: Ink(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(12),
                  //               color: Colors.white,
                  //             ),
                  //             height: 40,
                  //             width: 40,
                  //             child: Center(
                  //               child: Icon(
                  //                 Icons.location_searching_rounded,
                  //                 color: accentColor,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   Align(
                  //     alignment: Alignment.center,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(bottom: 34.0),
                  //       child: Icon(
                  //         Icons.location_pin,
                  //         color: accentColor,
                  //         size: 34,
                  //       ),
                  //     ),
                  //   ),
                  //   Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     right: 0,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: FillButton(
                  //         text: 'Pilih Alamat',
                  //         onTap: () {
                  //           print(_address.formatted);
                  //           Navigator.of(context).pop(_address);
                  //         },
                  //         leading: Container(),
                  //       ),
                  //     ),
                  //   ),
                  //   if (_isLoading)
                  //     Align(
                  //       alignment: Alignment.center,
                  //       child: CircularProgressIndicator(),
                  //     ),
                  // ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
