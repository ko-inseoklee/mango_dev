import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late List<Placemark> placemarks;

  late Position lat;

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
          child: Text('get loc'),
          onTap: () async {
            lat = await _determinePosition();
          },
        ),
        InkWell(
          child: Text('print address'),
          onTap: () async {
            placemarks = await placemarkFromCoordinates(lat.latitude, lat.longitude);
            print('adress: ');
            print(placemarks);
            print('------');
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
