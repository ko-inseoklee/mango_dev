import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mangodevelopment/viewModel/postViewModel.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  postViewModel postView = Get.put(postViewModel());

  late List<Placemark> placemarks;
  late double distance;

  late Position deviceLat;
  Position hguLat = Position(longitude: 129.38969404197408,
      latitude: 36.102863994751445,
      timestamp: DateTime.now(),
      accuracy: 50,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  @override
  void initState() {
    super.initState();
    // lat =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Column(children: [
        InkWell(
          child: Text('get device position'),
          onTap: () async {
            deviceLat = await _determinePosition();
          },
        ),
        InkWell(
          child: Text('print address'),
          onTap: () async {
            placemarks = await placemarkFromCoordinates(
                deviceLat.latitude, deviceLat.longitude);
            print('adress: ');
            print(placemarks);
            print('------');
          },
        ),
        InkWell(
          child: Text('calculate distance from handong'),
          onTap: () async {
            distance = await Geolocator.distanceBetween(
                deviceLat.latitude, deviceLat.longitude, hguLat.latitude,
                hguLat.longitude);
          },
        ),
        InkWell(
          child: Text('print distance from handong'),
          onTap: () {
            print('거리: $distance');
          },
        ),
        InkWell(
          child: Text('print distance from handong'),
          onTap: () {
            postView.loadLocalPosts(deviceLat);
          },
        ),
      ],),
    );
  }


  Future<void> getPosition() async {
    var currentPosition = await Geolocator.getCurrentPosition();
    // var lastPosition = await Geolocator
    //     .getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    print('위치');
    print(currentPosition);
    // print(lastPosition);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print('위치: ');
    print(await Geolocator.getCurrentPosition());
    return Geolocator.getCurrentPosition();
  }
}
