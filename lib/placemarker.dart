import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as Math;
class PlaceMarker extends GoogleMapExampleAppPage {
  PlaceMarker() : super(const Icon(Icons.place), 'Place marker');

  @override
  Widget build(BuildContext context) {
    return const PlaceMarkerBody();
  }
}
class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody();

  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}



class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  int _counter = 0;
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();


  GoogleMapController? mapController;
  LatLng _lastTap=LatLng(12.9569, 77.7011);
  List<LatLng> polyPoints = [];

  CameraPosition _kInitialPosition =
  CameraPosition(target: LatLng(12.9569, 77.7011), zoom: 11.0);
  List<Marker> mymarker=[];
  List<Polygon> _polygons=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Screenshot(
          controller: screenshotController,
          child:  GoogleMap(
            markers: Set.from(mymarker),
            polygons: Set.from(_polygons),
            initialCameraPosition: _kInitialPosition,
            mapType: MapType.hybrid,
            onTap: (LatLng pos) {
              _handleTap(pos);
            },
          ),
        ),

      ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: _removeTap,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red
                  ),
                  child: Icon(Icons.backspace, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: _calculateArea,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: save,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red
                  ),
                  child: Icon(Icons.save_alt, color: Colors.white),
                ),
              ),
            ),

         ]));

  }



  _drawPolygon(List<LatLng> listLatLng) {
    setState(() {
      _polygons.add(Polygon(
          polygonId: PolygonId('123'),
          points: listLatLng,
          fillColor: Colors.transparent,
          strokeColor: Colors.greenAccent));
    });
  }

  _calculateArea() {
    polyPoints.add(polyPoints[0]);
    print(calculatePolygonArea(polyPoints));
    Fluttertoast.showToast(
        msg: calculatePolygonArea(polyPoints).toString() +
            " Acres",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static double calculatePolygonArea(List coordinates) {
    double area = 0;

    if (coordinates.length > 2) {
      for (var i = 0; i < coordinates.length - 1; i++) {
        var p1 = coordinates[i];
        var p2 = coordinates[i + 1];
        area += convertToRadian(p2.longitude - p1.longitude) *
            (2 +
                Math.sin(convertToRadian(p1.latitude)) +
                Math.sin(convertToRadian(p2.latitude)));
      }

      area = area * 6378137 * 6378137 / 2;
    }

    return area.abs() * 0.000247105;  //sq meters to Acres
  }

  static double convertToRadian(double input) {
    return input * Math.pi / 180;
  }
  Future<void> _handleTap(LatLng pos) async {
    print(pos);
    final coordinates = new Coordinates(pos.latitude, pos.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);


    setState(() {
     // mymarker=[];
      polyPoints.add(pos);
      _drawPolygon(polyPoints);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      mymarker.add(Marker(
        markerId: MarkerId(pos.toString()),
        position: pos,
        infoWindow: InfoWindow(
          title: first.featureName,
          snippet: first.addressLine
        )
      ));
    });

  }

  Future<void> _removeTap() async {

    setState(() {
      // mymarker=[];

      mymarker.clear();
      _polygons.clear();
      polyPoints.clear();
    });

  }




  Future<void> save() async {
    PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    if (permissionResult == PermissionStatus.authorized){
      // code of read or write file in external storage (SD card)
      screenshotController
          .capture()
          .then((Uint8List image) async {
        //print("Capture Done");
        setState(() {
          _imageFile = image;
        });
        final result =
        await ImageGallerySaver.saveImage(image); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
        print("File Saved to Gallery");
      }).catchError((onError) {
        print(onError);
      });
    }
    else{
      tapped();
    }


  }

  tapped(){
    Fluttertoast.showToast(
        msg: "Please give storage permission",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  }


