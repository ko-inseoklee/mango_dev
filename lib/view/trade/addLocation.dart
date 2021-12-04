import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/view/trade/saveLocation.dart';
import 'package:mangodevelopment/view/trade/test.dart';
import 'package:mangodevelopment/view/trade/trade.dart';
import 'package:mangodevelopment/view/widget/dialog/confrirmDialog.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class addLocationPage extends StatefulWidget {
  GeoPoint deviceLat;

  addLocationPage({Key? key, required this.deviceLat}) : super(key: key);

  @override
  _addLocationPageState createState() => _addLocationPageState();
}

class _addLocationPageState extends State<addLocationPage> {
  UserViewModel userViewModelController = Get.find<UserViewModel>();
  late List<Placemark> placemarks;
  late GeoPoint location;

  // late GeoPoint deviceLat;
  late LatLng _lastMapPosition =
  LatLng(widget.deviceLat.latitude, widget.deviceLat.longitude);

  @override
  void initState() {
    super.initState();
    H().then((value) async {
      placemarks = await placemarkFromCoordinates(
          widget.deviceLat.latitude, widget.deviceLat.longitude);
      setState(() {
        if (userViewModelController.user.value.location == GeoPoint(0, 0))
          location =
              GeoPoint(widget.deviceLat.latitude, widget.deviceLat.longitude);
        else
          location = GeoPoint(
              userViewModelController.user.value.location.latitude,
              userViewModelController.user.value.location.longitude);
      });
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  // Marker _maker = Marker(
  //   markerId: MarkerId('value'),
  //   position:
  //   LatLng(deviceLat.latitude, deviceLat.longitude),
  //   icon: BitmapDescriptor.defaultMarker,
  // );

  void _updatePosition(CameraPosition _position) {
    print(_position.target.latitude);
    // _lastMapPosition = position.target;

    LatLng newMarkerPosition =
    LatLng(_position.target.latitude, _position.target.longitude);
    //   Marker marker = markers["marker"];
    //
    // setState(() {
    //   markers["marker"] = marker.copyWith(
    //       positionParam:
    //           LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
    // });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 위치 등록'),
      ),
      body: Center(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      location.latitude, location.longitude),
                  zoom: 16.0,
                ),
                mapType: MapType.normal,
                // markers: _marker,
                markers: Set<Marker>.of(<Marker>[
                  Marker(
                      onTap: () {
                        print('Tap');
                      },
                      draggable: true,
                      markerId: MarkerId("marker"),
                      position: LatLng(location.latitude,
                          location.longitude),
                      onDragEnd: ((newPosition) async {
                        placemarks = await placemarkFromCoordinates(
                            newPosition.latitude, newPosition.longitude);
                        setState(() {
                          location =
                              GeoPoint(newPosition.latitude,
                                  newPosition.longitude);
                          placemarks = placemarks;
                        });
                        // print(newPosition.latitude);
                        // print(newPosition.longitude);
                      }))
                ]),
                onCameraMove: ((_position) => _updatePosition(_position)),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      // height: 50,
                      //TODO: accent color
                      color: Theme
                          .of(context)
                          .accentColor
                          .withOpacity(0.3),
                      child: Text(
                          '${placemarks.first.street.toString()} ( ${location
                              .longitude.toString().substring(0, 5)}, ${location
                              .latitude.toString().substring(0, 4)} )'),
                    ),
                  ),
                  Expanded(flex: 12, child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      // margin: EdgeInsets.all(25),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          color: Colors.white,
                          child: ElevatedButton(
                              onPressed: () async {
                                userViewModelController.user.value.location =
                                    GeoPoint(
                                        location.latitude, location.longitude);
                                await userViewModelController
                                    .updateUserLocation(
                                    userViewModelController.userID,
                                    userViewModelController.user.value.location)
                                    .then((value) {
                                  Get.back();
                                  Get.dialog(ConfirmDialog(
                                      contentText: "동네 설정이 완료되었습니다.",
                                      onTapOK: () {
                                        // Get.to(Test());
                                        Get.back();
                                      }));
                                });
                              },
                              child: Text('동네 설정하기')),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }

  Future<void> H() async {}

  // Future<void> getCurrentLocation() async {
  //   var res = await Geolocator.getCurrentPosition();
  //   setState(() {
  //     widget.deviceLat = GeoPoint(res.latitude, res.longitude);
  //   });
  // }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition();
  }
}
