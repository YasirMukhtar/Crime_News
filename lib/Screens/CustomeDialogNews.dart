import 'dart:ui';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Models/notificationModel.dart';
import 'package:crime_news/Models/usernewsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10,top:10, right: 10,bottom: 50
          ),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('Notification',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: notificationlist.length == 0
                ? Container(
              child: Center(
                child: Text(
                  'No News Found',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ): ListView.builder(
              itemCount: notificationlist.length,
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
                        notificationlist[index].news,
                        style: TextStyle(color: Colors.black),
                      ),
                      Divider(
                          indent: 20,
                          endIndent: 20,
                          color: AppColors.mainColor),
                    ]));
              }), ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 30,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Image.asset("Assets/logo.png")
            ),
          ),
        ),
      ],
    );
  }
}