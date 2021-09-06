import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radauon/src/locations.dart' as locations;

class Location extends StatefulWidget {
  @override
  _Location createState() => _Location();
}

class _Location extends State<Location> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.campus),
          position: LatLng(office.latitude, office.longitude),
          infoWindow: InfoWindow(
            title: office.campus,
            snippet: office.phone,
          ),
        );
        _markers[office.campus] = marker;
      }
    });
    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /*appBar:Platform.isIOS?AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 27,
            ),
          ),
        ):SizedBox(height: 0,width: 0,),*/
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(-1.26811428, 36.67296870000001),
            zoom: 10,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
