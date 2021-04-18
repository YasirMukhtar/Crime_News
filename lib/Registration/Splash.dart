import 'dart:async';

import 'package:crime_news/API.dart';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Screens/Home.dart';
import 'package:crime_news/Screens/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Splash extends StatefulWidget {
  static SharedPreferences prefs;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  initi(){
    SharedPreferences.getInstance().then((prefs) {
      Splash.prefs = prefs;
    });
  }
  Future<void> main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? true;
    print(status);
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: status == true ? IntroPage() : Home()));
  }

  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @override
  startTime() async {
    return new Timer(Duration(milliseconds: 4500) , (){
      main();
    });
  }
  // To navigate layout change
  // void NavigatorPage() {
  //   main();
  // }
  void initState() {
    super.initState();
    initi();
    _getCurrentLocation();

    startTime();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

     // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);
  //
  //     Placemark place = p[0];
  //
  //     setState(() {
  //       _currentAddress =
  //       "${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    AppColors.lighterColor,
                    AppColors.mainColor,
                  ],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated
              )
          ),

          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('Assets/logo.png',width: 200,height: 200,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
