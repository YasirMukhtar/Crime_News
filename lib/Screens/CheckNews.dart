import 'dart:convert';

import 'package:crime_news/API.dart';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Models/Area_List.dart';
import 'package:crime_news/Models/GetCitiesModel.dart';
import 'package:crime_news/Models/GetDistrictModel.dart';
import 'package:crime_news/Models/GetTownModel.dart';
import 'package:crime_news/Models/news_model.dart';
import 'package:crime_news/Models/newsbyareaModel.dart';
import 'package:crime_news/Screens/IntroPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crime_news/Models/GetStateModel.dart';
import '../Global.dart';



class CheckNew extends StatefulWidget {
  static ProgressDialog pr;
  @override
  _CheckNewState createState() => _CheckNewState();
}

class _CheckNewState extends State<CheckNew> {

  String _mySelection;
  String valueChoose1;
  String valueChoose2;
  String valueChoose3;
  String valueChoose4;


  Future myFuture;

  final String uri = 'http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetStates';

  static Future<getStateModel> GetState() async {
    try {
      final http.Response response =
      await http.get("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetStates");

      if (response.statusCode == 200) {
        stateList.clear();

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

   Future<getcityModel> GetCities(var id) async {
    try {
      final http.Response response =
      await http.get("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetCitiesByStateId/$id");

      if (response.statusCode == 200) {
        citiesList.clear();
        set();
        return getcityModel.fromJson(jsonDecode(response.body));
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
   Future<getdistrictModel> GetDistrict(var id) async {
    try {
      final http.Response response =
      await http.get("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetDistrictByCityId/$id");

      if (response.statusCode == 200) {
        districtList.clear();
        set();
        return getdistrictModel.fromJson(jsonDecode(response.body));
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

  set(){

    new Future.delayed(new Duration(milliseconds: 1500), () {
      setState(() {

      });
    });
  }

   Future<getTownModel> GetTown(var id) async {
    try {
      final http.Response response =
      await http.get("http://107.174.33.194/plesk-site-preview/vh.pakgaming.pk/CrimeAlretsApi/GetTownByDistrictId/$id");

      if (response.statusCode == 200) {
        townList.clear();
        set();
        return getTownModel.fromJson(jsonDecode(response.body));

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
  @override
  initState() {
    // TODO: implement initState

    CheckNew.pr = ProgressDialog(context);
    addresslist.clear();
    setState(() {
      // myFuture = GetState();
    });

    // myFuture = GetCities();
    super.initState();
  }

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     updateListView();
  //   });
  // }

  @override
  final _formKey = GlobalKey<FormState>();
  final newsController = TextEditingController();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
              children: [
                SizedBox(height: 20,),
              //    FutureBuilder<getStateModel>(
              // future: myFuture,
              // builder: (context, snapshot) {
              //   if (!snapshot.hasData)
              //     return Center(child: Container());
              //   return  Container(
              //         child: DropdownButton(
              //                 items: stateList.map((item)=>DropdownMenuItem<String>(child: Text(item.name), value: item.name,)
              //                 ).toList(),
              //                 onChanged: (newVal) {
              //                   setState(() {
              //                     selectedSpinnerItem = newVal;
              //                   });
              //                 },
              //                 value: selectedSpinnerItem,
              //               )
              //             );
              // }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[400]),
                        borderRadius: BorderRadius.circular(5.0),),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Select Province'),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        iconSize: 12,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        value: valueChoose1,
                        onChanged: (newValue ) {
                          setState(() {
                            citiesList.clear();
                            districtList.clear();
                            townList.clear();
                            valueChoose1 = newValue;

                            print(newValue);
                            GetCities(newValue);


                          });
                        },
                        items: stateList.map((item)=>DropdownMenuItem<String>(child:
                            Text(item.name),
                          value: item.stateId.toString(),
                        )
                        ).toList(),
                      ),
                    ),
                    valueChoose1 != null ?  Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[400]),
                        borderRadius: BorderRadius.circular(5.0),),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Select City'),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        iconSize: 12,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        value: valueChoose2,
                        onChanged: (newValue) {
                          setState(() {
                            districtList.clear();
                            townList.clear();
                            valueChoose2 = newValue;
                            print(newValue);
                            GetDistrict(newValue);
                          });
                        },
                        items: citiesList.map((item)=>DropdownMenuItem<String>(child:
                        Text(item.name),
                          value: item.cityId.toString(),
                        )
                        ).toList(),
                      ) ,
                    ):Container(height: 2, width: 10,),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                valueChoose2 != null ? Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[400]),
                        borderRadius: BorderRadius.circular(5.0),),
                      child:DropdownButton(
                        isExpanded: true,
                        hint: Text('Select District '),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        iconSize: 12,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        value: valueChoose3,
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose3 = newValue;
                            print(newValue);
                            townList.clear();
                            GetTown(newValue);
                          });
                        },
                        items: districtList.map((item)=>DropdownMenuItem<String>(child:
                        Text(item.name),
                          value: item.districtId.toString()
                        )
                        ).toList(),
                      ),
                    ):Container(),
                     valueChoose3 != null ?Container(
                      width: MediaQuery.of(context).size.width/2.4,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[400]),
                        borderRadius: BorderRadius.circular(5.0),),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text('Select Town'),
                        dropdownColor: Colors.grey[100],
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        iconSize: 12,
                        underline: SizedBox(),
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        value: valueChoose4,
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose4 = newValue;
                          });
                        },
                        items: townList.map((item)=>DropdownMenuItem<String>(child:
                        Text(item.name),
                            value: item.name.toString()
                        )
                        ).toList(),
                      ) ,
                    ):Container(),
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                    onTap: () {

                      valueChoose4 != null? getnewsbyareacheck(valueChoose4.toString()):   Fluttertoast.showToast(
                          msg: "Select Fields!", toastLength: Toast.LENGTH_LONG);;

                    //   FutureBuilder<NewsModel>(
                    //       future: API().getnewsbyarea(valueChoose4.toString()));
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
                    )),

                SizedBox(height: 20,),

                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        color: AppColors.lighterColor,
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                         child:
                        addresslist.length== 0
                            ?
                        RefreshIndicator(
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
                       child:  ListView.builder(
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
                                      addresslist[index].news,
                                       style: TextStyle(color: Colors.black),
                                     ),
                                     Divider(
                                         indent: 20,
                                         endIndent: 20,
                                         color: AppColors.mainColor),
                                   ]));
                             }),
                          onRefresh:_getData ,
                        )

                        // FutureBuilder<NewsModel>(
                        //   future: API().getnewsbyarea(valueChoose4.toString()),
                        //     builder: (ct,sp){
                        //       return ListView.builder(
                        //           itemCount: sp.data.responseObject.length,
                        //           scrollDirection: Axis.vertical,
                        //           itemBuilder: (BuildContext context, int index) {
                        //             return Container(
                        //                 padding: EdgeInsets.only(left: 3, right: 3),
                        //                 width:
                        //                 MediaQuery.of(context).size.width / 2,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(5),
                        //                   // image: DecorationImage(
                        //                   //   image: AssetImage(earnList[index].image),
                        //                   //   fit: BoxFit.cover,
                        //                   // ),
                        //                 ),
                        //                 child: Column(children: [
                        //                   Text(
                        //                     sp.data.responseObject[index].nEWS,
                        //                     style: TextStyle(color: Colors.black),
                        //                   ),
                        //                   Divider(
                        //                       indent: 20,
                        //                       endIndent: 20,
                        //                       color: AppColors.mainColor),
                        //                 ]));
                        //           });
                        // })
                    ),
                  ),
                ),


              ],
            )),
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
