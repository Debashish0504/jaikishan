//@dart=2.11
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'mapsdetails.dart';





class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
//Splash screen
class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 7,
      navigateAfterSeconds: new MapsDetails(),
      title: new Text(
        'JaiKishan',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset('assets/jaikishan.png',width: 240,height: 240,),
      backgroundColor: Colors.white,
      loaderColor: Colors.lightBlue,
    );
  }

}





void main() {
  runApp(MaterialApp(home: MyApp()));
}
