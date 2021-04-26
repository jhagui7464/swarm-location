import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Completer<GoogleMapController> _controller = Completer();
  double lat;
  double lon;
  List<Marker> _markers = <Marker>[];

  void translatePing(String test) {
    List<String> listofCoordinates = [];

    //we filter the string to be split into a list
    String holder = '';
    for (int i = 0; i < test.length; ++i) {
      if (test[i] != ',') {
        holder += test[i];
      } else {
        listofCoordinates.add(holder);
        holder = '';
      }
    }
    listofCoordinates.add(holder);

    String nCoordinate;
    String wCoordinate;
    for (int i = 0; i < listofCoordinates.length; ++i) {
      if (listofCoordinates[i] == 'N') {
        nCoordinate = listofCoordinates[i - 1];
      } else if (listofCoordinates[i] == 'W') {
        wCoordinate = listofCoordinates[i - 1];
      }
    }

    String holder1 = nCoordinate.substring(0, 2);
    String holder2 = nCoordinate.substring(2);
    lat = double.parse(holder1) + (double.parse(holder2) / 60);

    holder1 = wCoordinate.substring(0, 3);
    holder2 = wCoordinate.substring(3);
    lon = -1 * (double.parse(holder1) + (double.parse(holder2) / 60));

    _markers.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: 'The title of the marker')));
  }

  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapping'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refresh,
        label: Text('Refresh'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _refresh() async {
    final GoogleMapController controller = await _controller.future;
    translatePing("2611.5737,N,09813.4431,W");
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lon), zoom: 11.0, tilt: 0, bearing: 0)));
  }
}
