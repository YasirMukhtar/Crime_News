import 'package:crime_news/Global.dart';
import 'package:dio/dio.dart';

class getTownModel {
  bool isSuccess;
  List<ResponseObjectTown> responseObject;
  Null responseString;
  Null error;
  Null requestedObject;
  Null redirectionUrl;
  Null exception;

  getTownModel(
      {this.isSuccess,
        this.responseObject,
        this.responseString,
        this.error,
        this.requestedObject,
        this.redirectionUrl,
        this.exception});

  getTownModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['ResponseObject'] != null) {
      responseObject = new List<ResponseObjectTown>();
      json['ResponseObject'].forEach((v) {
        responseObject.add(new ResponseObjectTown.fromJson(v));
      });
    }
    responseString = json['ResponseString'];
    error = json['Error'];
    requestedObject = json['RequestedObject'];
    redirectionUrl = json['RedirectionUrl'];
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    if (this.responseObject != null) {
      data['ResponseObject'] =
          this.responseObject.map((v) => v.toJson()).toList();
    }
    data['ResponseString'] = this.responseString;
    data['Error'] = this.error;
    data['RequestedObject'] = this.requestedObject;
    data['RedirectionUrl'] = this.redirectionUrl;
    data['exception'] = this.exception;
    return data;
  }
}

class ResponseObjectTown {
  int townId;
  int districtId;
  String districtName;
  String name;

  ResponseObjectTown({this.townId, this.districtId, this.districtName, this.name});

  ResponseObjectTown.fromJson(Map<String, dynamic> json) {
    townId = json['TownId'];
    districtId = json['DistrictId'];
    districtName = json['DistrictName'];
    name = json['Name'];

    townList.add(ResponseObjectTown(
        townId : json['TownId'],
        districtId : json['DistrictId'],
        districtName : json['DistrictName'],
    name : json['Name'],
    ));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TownId'] = this.townId;
    data['DistrictId'] = this.districtId;
    data['DistrictName'] = this.districtName;
    data['Name'] = this.name;
    return data;
  }
}