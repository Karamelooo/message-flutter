import 'dart:async';

import 'package:firstbd233/controller/permission_gps.dart';
import "package:geolocator/geolocator.dart";
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyDataMaps extends StatefulWidget {
  Position coordonnee;
  MyDataMaps({required this.coordonnee,super.key});

  @override
  State<MyDataMaps> createState() => _MyDataMapsState();
}

class _MyDataMapsState extends State<MyDataMaps> {
  // variables
  Completer<GoogleMapController> completer = Completer();
  late CameraPosition camera;
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId("kfsdlf"),
        position: LatLng(48.85341, 2.34444)
        )
    };

  @override
  void initState() {
    // TODO: implement initState
    camera = CameraPosition(target: LatLng(widget.coordonnee.latitude, widget.coordonnee.longitude), zoom: 14);
    super.initState();
  }
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: camera,
      onMapCreated: (mapsController) async {
        String newStyle = await DefaultAssetBundle.of(context).loadString("lib/new_style_map.json");
        mapsController.setMapStyle(newStyle);
        completer.complete(mapsController);
      }
    );
  }
}