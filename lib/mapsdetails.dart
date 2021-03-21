import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'placemarker.dart';

import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
class MapsDetails extends StatefulWidget {


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MapsDetails> {

  Location location = new Location();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();
  }

  bool _serviceEnabled=false;
  Future<void> permission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled){
      tapped();
    }
  }

  tapped(){
    Fluttertoast.showToast(
        msg: "Please switch on your GPS to use service",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: Column(
          children: [
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.grey,
            child: ElevatedButton(

            onPressed: () {
              if (_serviceEnabled) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PlaceMarker()));
              } else {
                  tapped();
              }
            },

            child: new Text("Place Marker", style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    ),
          ),

          ],
    )
    ,
    );
  }
}

