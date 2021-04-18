import 'dart:async';

import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Global.dart';
import 'package:crime_news/Models/LoginModel.dart';
import 'package:crime_news/Models/newsbyareaModel.dart';
import 'package:crime_news/Models/notificationModel.dart';
import 'package:crime_news/Models/usernewsModel.dart';
import 'package:crime_news/Registration/Splash.dart';
import 'package:crime_news/Registration/login.dart';
import 'package:crime_news/Screens/CheckNews.dart';
import 'package:crime_news/Screens/CustomeDialogNews.dart';
import 'package:crime_news/Screens/IntroPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API.dart';

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

  @override
  initState() {
    // TODO: implement initState
    Home.pr = ProgressDialog(context);
    setBool();

    final loginarea =  Splash.prefs.getString('userAREA');
    final  loginid =  Splash.prefs.getString('userID');

    API.getusernews( loginarea , loginid );
    StartTime();
    super.initState();
  }

StartTime() async{
 return new Timer.periodic(Duration(seconds: 10), (timer) {
   final  loginid =  Splash.prefs.getString('userID');
   print('notification working ');
   API.getnewsNotification(int.parse(loginid));
   if(notificationlist.length != 0){
     CustomDialogBox();
   }
   print('notification');
  });
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
                        child: usernewslist.length == 0
                            ? Container(
                                child: Center(
                                  child: Text(
                                    'No News Found',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: usernewslist.length,
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
                                          usernewslist[index].news,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Divider(
                                            indent: 20,
                                            endIndent: 20,
                                            color: AppColors.mainColor),
                                      ]));
                                })),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CheckNew()),);

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
}
