import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLocation();
  }

  void getLocation() async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then(
        (snapshot) {
          if (snapshot.exists) {
            final lat = snapshot.data()!['location'][0];
            final lon = snapshot.data()!['location'][1];
            final profile = snapshot.data()!['name'];
            final aboutMe = snapshot.data()!['about_me'];
            mapController.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(snapshot.data()!['location'][0], snapshot.data()!['location'][1]), 15));
            _addMarker(lat, lon, profile, aboutMe);
          }
        },
      );
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  MapType _currentMapType = MapType.normal;

  final CameraPosition _defaultLocation = CameraPosition(target: LatLng(1, 1), zoom: 10);
  final Set<Marker> _markers = {};

  void _addMarker(double lat, double lon, String profile, String aboutMe) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('default location'),
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarker,
          draggable: true,
          onDragEnd: (value) {},
          infoWindow: InfoWindow(
              //title and snippet on pin to describe it
              title: profile,
              snippet: aboutMe),
        ),
      );
    });
  }

  void _changeMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  // Future<void> _moveLocation() async {
  //   const newPosition = LatLng(34.4808, -1.2426);
  //   mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
  //   setState(() {
  //     const marker = Marker(
  //       markerId: MarkerId('new location'),
  //       position: newPosition,
  //       infoWindow: InfoWindow(title: 'test 2', snippet: 'Lalala'),
  //       draggable: true,
  //     );
  //     _markers
  //       ..clear()
  //       ..add(marker);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          mapType: _currentMapType,
          initialCameraPosition: _defaultLocation,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
        Container(
            padding: const EdgeInsets.only(top: 24, right: 12),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                // FloatingActionButton(
                //     onPressed: _addMarker(lat,lon),
                //     backgroundColor: Color.fromARGB(255, 24, 30, 102),
                //     foregroundColor: Colors.white,
                //     child: const Icon(Icons.add_location),
                //     shape: CircleBorder()),
                const SizedBox(
                  height: 5,
                ),
                FloatingActionButton(
                  onPressed: _changeMapType,
                  backgroundColor: Color.fromARGB(255, 29, 140, 44),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.landscape_sharp),
                  shape: CircleBorder(),
                ),
                const SizedBox(
                  height: 5,
                ),
                // FloatingActionButton(
                //     onPressed: _moveLocation,
                //     backgroundColor: Colors.amber,
                //     foregroundColor: Colors.white,
                //     child: const Icon(Icons.explore_rounded),
                //     shape: CircleBorder())
              ],
            ))
      ],
    ));
  }
}
