import 'dart:ffi';

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

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  MapType _currentMapType = MapType.normal;

  static const CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(51.496123, -0.136923), zoom: 10);
  final Set<Marker> _markers = {};

  void _addMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('default location'),
          position: _defaultLocation.target,
          icon: BitmapDescriptor.defaultMarker,
          draggable: true,
          onDragEnd: (value) {},
          infoWindow: const InfoWindow(
              //title and snippet on pin to describe it
              title: 'Test title',
              snippet: 'Hello i am a test snippet'),
        ),
      );
    });
  }

  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Future<void> _moveLocation() async {
    const newPosition = LatLng(53.4808, -2.2426);
    mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
    setState(() {
      const marker = Marker(
        markerId: MarkerId('new location'),
        position: newPosition,
        infoWindow: InfoWindow(title: 'test 2', snippet: 'Lalala'),
      );
      _markers
        ..clear()
        ..add(marker);
    });
  }

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
                FloatingActionButton(
                    onPressed: _addMarker,
                    backgroundColor: Color.fromARGB(255, 24, 30, 102),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add_location),
                    shape: CircleBorder()),
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
                FloatingActionButton(
                    onPressed: _moveLocation,
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.explore_rounded),
                    shape: CircleBorder())
              ],
            ))
      ],
    ));
  }
}
