import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mangodevelopment/viewModel/userViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class addLocationPage extends StatefulWidget {
  @override
  _addLocationPageState createState() => _addLocationPageState();
}

class _addLocationPageState extends State<addLocationPage> {

  UserViewModel userViewModelController = Get.find<UserViewModel>();
  late Position deviceLat;
  late LatLng _lastMapPosition = LatLng(deviceLat.latitude, deviceLat.longitude);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }


  final Completer<GoogleMapController> _controller = Completer();
  // Marker _maker = Marker(
  //   markerId: MarkerId('value'),
  //   position:
  //   LatLng(deviceLat.latitude, deviceLat.longitude),
  //   icon: BitmapDescriptor.defaultMarker,
  // );


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
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
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(deviceLat.latitude, deviceLat.longitude),
              zoom: 16.0,
            ),
            mapType: MapType.normal,
            // markers: _markers,
            onCameraMove: _onCameraMove,
          ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    var res = await Geolocator.getCurrentPosition();
    setState(() {
      deviceLat = res;
      // _center = LatLng(pos.latitude, pos.longitude);
      // print(pos);
    });
  }

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
    print('위치: ');
    print(await Geolocator.getCurrentPosition());
    return Geolocator.getCurrentPosition();
  }
}
