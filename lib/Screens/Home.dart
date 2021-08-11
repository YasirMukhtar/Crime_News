import 'dart:async';
import 'dart:convert';

import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Global.dart';
import 'package:crime_news/Models/GetStateModel.dart';
import 'package:crime_news/Models/LoginModel.dart';
import 'package:crime_news/Models/newsbyareaModel.dart';
import 'package:crime_news/Models/notificationModel.dart';
import 'package:crime_news/Models/usernewsModel.dart';
import 'package:crime_news/Registration/Splash.dart';
import 'package:crime_news/Registration/login.dart';
import 'package:crime_news/Screens/CheckNews.dart';
import 'package:crime_news/Screens/CustomeDialogNews.dart';
import 'package:crime_news/Screens/IntroPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';


import '../API.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static ProgressDialog pr;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  setBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    prefs.setBool('isLoggedIn', false);

  }
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Future myFuture;

  final String uri = 'http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetStates';

  static Future<getStateModel> GetState() async {
    try {
      final http.Response response =
      await http.get("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetStates");

      if (response.statusCode == 200) {
        stateList.clear();
        datacheck=true;
        return getStateModel.fromJson(jsonDecode(response.body));
      }
    }
    // on SocketException catch (e) {
    //   throw NoInternetExceptions("No Internet", "assets/internet.png");
    // } on HttpException catch (e) {
    //   throw HttpException("No Service found");
    // } on FormatException catch (e) {
    //   throw InvalidDataFormat("Invalid Data format");
    // }
    catch (e) {
      throw Exception("Unknown Error");
    }
  }
  getnewsbyareacheck(var  areaname ) async{
    CheckNew.pr.show();
    success = "false";
    String Url= "http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserAlertsbyarea";

    FormData formData = new FormData.fromMap({
      'area': areaname.toString(),
    });

    Dio dio = new Dio();
    try {
      dio.post(Url, data: formData).then((response){
        Map<String, dynamic> data = response.data;
        var status = data['IsSuccess'];
        if(status){
          var records=data["ResponseObject"];
          addresslist.clear();

          for (Map i in records) {
            // setState((){
            addresslist.add(apilist(
              id: i['AlertId'],
              news: i['NEWS'],
              area: i['AREA'],
              date:i['DATE'] ,

            ));
            // });

            success = "true";
          }
          CheckNew.pr.hide();
          setState(() {
            addresslist;
          });
          print('done');
        }
        else{
          success = "error";
          print('error');
        }
      });

    }catch (e) {
      success = "error";
      print('Error: $e');
    }
  }

   Future<List<Usernewslist>> getuserNotification(var  areaname , var id  , latitude , longitude) async{
     usernewslist.clear();
    print("getuserNotification");
    success = "false";
    String Url= "http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserUnreadAlertsbyArea";
    print("latitude is: $latitude");
    print("latitude is: $longitude");
    FormData formData = new FormData.fromMap({
      'UserId' : id ,
      'Location_X' : latitude,
      'Location_Y' : longitude,
      'area': '',
    });

    Dio dio = new Dio();
    try {
      await dio.post(Url, data: formData).then((response){
        print("json is: ${response.data}");
        // var data={"IsSuccess": true, "ResponseObject": [], "ResponseString": null, "Error": null, "RequestedObject": null,
        // "RedirectionUrl": null, "exception": null};
        Map<String, dynamic> data = response.data;
        //Map data = response.data;
        print("data is: $data");
        var status = data['IsSuccess'];
        if(status ){
          List records=data["ResponseObject"];
          print("records size: ${records.length}");
          for (Map i in records) {
            usernewslist.add(Usernewslist(
              id: i['AlertId'],
              news: i['NEWS'],
              area: i['AREA'],
              date:i['DATE'] ,

            ));
            success = "true";
          }
          setState(() {
            usernewslist;
          });
          print('done');
        }
        else{
          success = "error";
          print('error');
        }
      });
    }catch (e) {
      success = "error";
      print('Error: $e');
    }
    finally{
      return usernewslist;
    }

  }
  _getCurrentLocation() {
    print('CurrentLocationnotification');
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      final loginarea =  Splash.prefs.getString('userAREA');
      final  loginid =  Splash.prefs.getString('userID');
      print(_currentPosition);
      getuserNotification(loginarea, loginid , _currentPosition.latitude , _currentPosition.longitude).then((value) {
        print("value is: $value");
          if(usernewslist.length != 0){
             print('CurrentLocatification');
        showDialog(context: context,
            builder: (BuildContext context) {
              return
                CustomDialogBox();
            });
          }
        print('CurrentLocationnotification');

        setState(() {
          _currentPosition = position;
          print(_currentPosition);

        });
      });


    }).catchError((e) {
      print(e);
    });
  }
  @override
  initState() {
    // TODO: implement initState
    Home.pr = ProgressDialog(context);
    setBool();
    datacheck=false;

    CheckNew.pr = ProgressDialog(context);
   // addresslist.clear();

     final loginarea =  Splash.prefs.getString('userAREA');
    // getnewsbyareacheck( loginarea);
    // final  loginid =  Splash.prefs.getString('userID');
    //  print(loginarea);
    //  print(loginid);
    //
    // getusernews( loginarea , loginid );

    StartTime();
    super.initState();
    // new Future.delayed(Duration.zero, () {
    //   showDialog(context: context,
    //       builder: (BuildContext context) {
    //         return new Container(child: new Text('foo'));
    //       });
    // });


  }

StartTime() async{

  // new Future.delayed(Duration.zero, () {
  //   _getCurrentLocation();
  //     //  final loginarea =  Splash.prefs.getString('userAREA');
  //     //  final  loginid =  Splash.prefs.getString('userID');
  //     //  getuserNotification(loginarea, loginid , _currentPosition.latitude , _currentPosition.longitude);
  //     // // if(usernewslist.length != 0){
  //     // //     print('CurrentLocationnotification');
  //     //     showDialog(context: context,
  //     //         builder: (BuildContext context) {
  //     //           return
  //     //             CustomDialogBox();
  //     //          });
  //     //   // }
  //     //   print('CurrentLocationnotification');
  //
  // });

 return new Timer.periodic(Duration(seconds: 5), (timer) {
   print('Notification');
    _getCurrentLocation();
 //   final loginarea =  Splash.prefs.getString('userAREA');
 //   final  loginid =  Splash.prefs.getString('userID');
 //   // getuserNotification(loginarea, loginid , _currentPosition.latitude , _currentPosition.longitude);
 // //  if(usernewslist.length != 0){
 //     print('CurrentLocationnotification');
 //    CustomDialogBox();
 // //  }
 //   print('CurrentLocationnotification');
   // print('notification');
  });
}

@override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final newsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                RaisedButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.of(context).pop(true)),
                RaisedButton(
                    child: Text('No'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            "Crime Analyser",
            style: AppFonts.monmbold1,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    //Return String
                    prefs.setBool('isLoggedIn', true);
                    prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => IntroPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Icon(Icons.logout)),
            )
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height : MediaQuery.of(context).size.height/1.9,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                         color: AppColors.lighterColor,
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: MediaQuery.of(context).size.height / 1.15,
                        child: addresslist.length== 0
                            ?  RefreshIndicator(
                            onRefresh: _getData,
                            child: SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height/1.8,
                                child: Center(
                                  child: Text(
                                    'No News Found',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                        )
                            :RefreshIndicator(
                          child:   ListView.builder(
                              physics:BouncingScrollPhysics(),
                              itemCount: addresslist.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    padding: EdgeInsets.only(left: 3, right: 3),
                                    width:
                                    MediaQuery.of(context).size.width / 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // image: DecorationImage(
                                      //   image: AssetImage(earnList[index].image),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                    child: Column(children: [
                                      Text(
                                        addresslist[index].news == null ? ' No News ':addresslist[index].news,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Divider(
                                          indent: 20,
                                          endIndent: 20,
                                          color: AppColors.mainColor),
                                    ]));
                              }),
                          // ListView.builder(
                          //     itemCount: usernewslist.length,
                          //     scrollDirection: Axis.vertical,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Container(
                          //           padding: EdgeInsets.only(left: 3, right: 3),
                          //           width:
                          //           MediaQuery.of(context).size.width / 2,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(5),
                          //             // image: DecorationImage(
                          //             //   image: AssetImage(earnList[index].image),
                          //             //   fit: BoxFit.cover,
                          //             // ),
                          //           ),
                          //           child: Column(children: [
                          //             Text(
                          //               usernewslist[index].news,
                          //               style: TextStyle(color: Colors.black),
                          //             ),
                          //             Divider(
                          //                 indent: 20,
                          //                 endIndent: 20,
                          //                 color: AppColors.mainColor),
                          //           ]));
                          //     }),
                          onRefresh:_getData ,
                        )),
                  ),

                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      children: [
                        Text('Click Here to Check Other Area News'),
                        Spacer(),
                        InkWell(
                            onTap: () {

                              myFuture = GetState();
                              if(datacheck==true)
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CheckNew()),);
                                }


                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(
                                    'Check',
                                    style: TextStyle(color: AppColors.blueColor , fontSize: 15),
                                  )),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.55,
                            child: TextFormField(
                              controller: newsController,
                              validator:  (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.mainColor,
                                    )),
                                hintText: 'Enter News to Check ',
                                hintStyle: AppFonts.monm12bold,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                Home.pr.show();
                                API.CheckNews(context, newsController.text.toString());
                              }
                            },
                            child: Container(
                              height: 58,
                              width: 80,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(
                                'Check',
                                style: TextStyle(color: AppColors.white),
                              )),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              )),
        ),
      ),
    );
  }
  Future<void> _getData() async {
    setState(() {
      setState(() {
        addresslist.length;
      });

    });
  }
}
