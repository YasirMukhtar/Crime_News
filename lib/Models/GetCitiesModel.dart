import 'package:crime_news/Global.dart';

class getcityModel {
  bool isSuccess;
  List<ResponseObjectCity> responseObject;
  Null responseString;
  Null error;
  Null requestedObject;
  Null redirectionUrl;
  Null exception;

  getcityModel(
      {this.isSuccess,
        this.responseObject,
        this.responseString,
        this.error,
        this.requestedObject,
        this.redirectionUrl,
        this.exception});

  getcityModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['ResponseObject'] != null) {
      responseObject = new List<ResponseObjectCity>();
      json['ResponseObject'].forEach((v) {
        responseObject.add(new ResponseObjectCity.fromJson(v));
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

class ResponseObjectCity {
  int cityId;
  int stateId;
  String stateName;
  String name;

  ResponseObjectCity({this.cityId, this.stateId, this.stateName, this.name});

  ResponseObjectCity.fromJson(Map<String, dynamic> json) {
    cityId = json['CityId'];
    stateId = json['StateId'];
    stateName = json['StateName'];
    name = json['Name'];


    citiesList.add(ResponseObjectCity(
        cityId : json['CityId'],
        stateId : json['StateId'],
        stateName : json['StateName'],
    name : json['Name'],
    ));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CityId'] = this.cityId;
    data['StateId'] = this.stateId;
    data['StateName'] = this.stateName;
    data['Name'] = this.name;
    return data;
  }
}