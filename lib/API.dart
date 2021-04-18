import 'dart:convert';

import 'package:crime_news/Models/LoginModel.dart';
import 'package:crime_news/Models/news_model.dart';
import 'package:crime_news/Models/newsbyareaModel.dart';
import 'package:crime_news/Models/notificationModel.dart';
import 'package:crime_news/Models/usernewsModel.dart';
import 'package:crime_news/Registration/ForgotPassword.dart';
import 'package:crime_news/Registration/Signup.dart';
import 'package:crime_news/Registration/Splash.dart';
import 'package:crime_news/Registration/login.dart';
import 'package:crime_news/Screens/CheckNews.dart';
import 'package:crime_news/Screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global.dart';




class API{
  static login(BuildContext context ,email ,password) async {
    success = "false";
    FormData data = FormData.fromMap({
      "Email": email,
      "Password": password,
    });

    Dio dio = new Dio();

    dio.post("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/Auth", data: data)
        .then((response) async {

      print(response.statusCode);
      Map<String, dynamic> data = response.data;
      userlogin = data['IsSuccess'];

      if (response.statusCode == 200) {

        if (userlogin == true) {
          var records=data["ResponseObject"];

            userId=records['UserId'] ;
            name=records["NAME"];
            Email=records["EMAIL"] ;
            password =records["PASSWORD"] ;
            LOCATION_X=records["LOCATION_X"] ;
            LOCATION_Y=records["LOCATION_Y"] ;
            userarea=records["AREA"] ;

           Splash.prefs.setString('userID', userId.toString());
           Splash.prefs.setString('userAREA', userarea.toString());


          Login.pr.hide();
          print(userId);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),);

        }
        else{
          Login.pr.hide();
          Fluttertoast.showToast(
              msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
        }

      }
      else if (response.statusCode == 202) {
        Login.pr.hide();
        Fluttertoast.showToast(
            msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error)  {

      Fluttertoast.showToast(
        msg: error, toastLength: Toast.LENGTH_LONG);});
  }
  static SignupUser(BuildContext context ,username ,email ,password , latitude , longitude ,  ){
    FormData data = FormData.fromMap({
      "UserId" : '0',
      "NAME": username,
      "EMAIL": email,
      "PASSWORD": password,
      "LOCATION_X": latitude,
      "LOCATION_Y": longitude,
      "AREA": "null",



    });

    Dio dio = new Dio();

    dio.post("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/AddUser", data: data)
        .then((response) {

      print(response.statusCode);
      Map<String, dynamic> data = response.data;
      status = data['ResponseString'];
      if (response.statusCode == 200) {

        if(status == null){

          print('registered');
          Signup.pr.hide() ;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
        else{
          Signup.pr.hide() ;
          Fluttertoast.showToast(
              msg: 'This E-Mail already exists!', toastLength: Toast.LENGTH_LONG);
        }
          print('This Email ALready Exits');




      }
      else if (response.statusCode == 202) {
        Signup.pr.hide() ;
        Fluttertoast.showToast(
            msg: 'This E-Mail already exists!', toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) { Signup.pr.hide();
    Fluttertoast.showToast(
        msg: error, toastLength: Toast.LENGTH_LONG);});
  }

  static ForgetPassword(BuildContext context ,email ){
    FormData data = FormData.fromMap({
      "UserMail": email,

    });

    Dio dio = new Dio();

    dio.post("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/ForgetPassword", data: data)
        .then((response) {

      print(response.statusCode);
      Map<String, dynamic> data = response.data;
      userlogin = data['IsSuccess'];
      print(userlogin);
      if (response.statusCode == 200) {

        if (userlogin == true){
          print(userlogin);
          ForgotPassword.pr.hide();
          Fluttertoast.showToast(
              msg: 'Email Sent To your Registered Email ', toastLength: Toast.LENGTH_LONG);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),);

        }
        else{
          ForgotPassword.pr.hide();
          Fluttertoast.showToast(
              msg: "Enter Your Correct Registered Email", toastLength: Toast.LENGTH_LONG);
        }

      }
      else if (response.statusCode == 202) {
        ForgotPassword.pr.hide();
        Fluttertoast.showToast(
            msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) {
      ForgotPassword.pr.hide();
       Fluttertoast.showToast(
        msg: error, toastLength: Toast.LENGTH_LONG);});
  }

  static NewsByArea(BuildContext context ,area){
    FormData data = FormData.fromMap({
      "area": area,
    });

    Dio dio = new Dio();

    dio.post("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserAlertsbyarea", data: data)
        .then((response) {

      print(response.statusCode);
      Map<String, dynamic> data = response.data;
      userlogin = data['IsSuccess'];

      if (response.statusCode == 200) {

        if (userlogin == true){
          print(userlogin);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),);

        }
        else{
          Fluttertoast.showToast(
              msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
        }

      }
      else if (response.statusCode == 202) {
        Fluttertoast.showToast(
            msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) => print(error));
  }

  static CheckNews(BuildContext context ,news ){
    FormData data = FormData.fromMap({
      "msg": news,

    });

    Dio dio = new Dio();

    dio.post("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/IsCrime", data: data)
        .then((response) {

      print(response.statusCode);
      Map<String, dynamic> data = response.data;
      newsResult = data['ResponseObject'];
      print(newsResult);
      if (response.statusCode == 200) {

        if (newsResult == true){
          print(userlogin);
          Fluttertoast.showToast(
              msg: "Its a Crime News",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );

        }
        else if (newsResult == false){
          Fluttertoast.showToast(
              msg: "Its not  Crime News",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );

        }

      }
      else if (response.statusCode == 202) {
        Fluttertoast.showToast(
            msg: "Email & Password does'nt Match!", toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) => print(error));
  }

  Future<NewsModel> getnewsbyarea(var  areaname ) async{
    // success = "false";
    // String Url= "http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserAlertsbyarea";

    Map<String, dynamic> jsonMap = {
      'area': areaname.toString(),

    };
    try {
      final http.Response response =
      await http.post(Uri.http('http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserAlertsbyarea' , jsonMap));

      if (response.statusCode == 201) {
        return NewsModel.fromJson(jsonDecode(response.body));
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


    // FormData formData = new FormData.fromMap({
    //   'area': areaname.toString(),
    // });
    //
    // Dio dio = new Dio();
    // try {
    //   dio.post(Url, data: formData).then((response){
    //     Map<String, dynamic> data = response.data;
    //     var status = data['IsSuccess'];
    //     if(status){
    //       var records=data["ResponseObject"];
    //       addresslist.clear();
    //
    //       for (Map i in records) {
    //
    //         addresslist.add(apilist(
    //           id: i['AlertId'],
    //           news: i['NEWS'],
    //           area: i['AREA'],
    //           date:i['DATE'] ,
    //
    //         ));
    //         success = "true";
    //       }
    //       CheckNew.pr.hide();
    //       print('done');
    //     }
    //     else{
    //       success = "error";
    //       print('error');
    //     }
    //   });
    //
    // }catch (e) {
    //   success = "error";
    //   print('Error: $e');
    // }
  }



  static getnewsNotification(int id ) async{
    success = "false";
    String Url= "http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserUnreadAlerts";
    FormData formData = new FormData.fromMap({
      'Id': id,
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

            notificationlist.add(Notificationlist(
              id: i['AlertId'],
              news: i['NEWS'],
              area: i['AREA'],
              date:i['DATE'] ,

            ));
            success = "true";
          }

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

  static getusernews(var  areaname , var id ) async{
    success = "false";
    String Url= "http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetUserUnreadAlertsbyArea";
    FormData formData = new FormData.fromMap({
      'UserId' : id ,
      'area': areaname.toString(),
    });

    Dio dio = new Dio();
    try {
      dio.post(Url, data: formData).then((response){
        Map<String, dynamic> data = response.data;
        var status = data['IsSuccess'];
        if(status){
          var records=data["ResponseObject"];
          usernewslist.clear();
          for (Map i in records) {

            usernewslist.add(Usernewslist(
              id: i['AlertId'],
              news: i['NEWS'],
              area: i['AREA'],
              date:i['DATE'] ,

            ));
            success = "true";
          }
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
}