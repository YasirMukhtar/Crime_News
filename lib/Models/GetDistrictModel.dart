import 'package:crime_news/Global.dart';

class getdistrictModel {
  bool isSuccess;
  List<ResponseObjectDistrict> responseObject;
  Null responseString;
  Null error;
  Null requestedObject;
  Null redirectionUrl;
  Null exception;

  getdistrictModel(
      {this.isSuccess,
        this.responseObject,
        this.responseString,
        this.error,
        this.requestedObject,
        this.redirectionUrl,
        this.exception});

  getdistrictModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['ResponseObject'] != null) {
      responseObject = new List<ResponseObjectDistrict>();
      json['ResponseObject'].forEach((v) {
        responseObject.add(new ResponseObjectDistrict.fromJson(v));
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

class ResponseObjectDistrict {
  int districtId;
  int cityId;
  String cityName;
  String name;

  ResponseObjectDistrict({this.districtId, this.cityId, this.cityName, this.name});

  ResponseObjectDistrict.fromJson(Map<String, dynamic> json) {
    districtId = json['DistrictId'];
    cityId = json['CityId'];
    cityName = json['CityName'];
    name = json['Name'];

    districtList.add(ResponseObjectDistrict(
      districtId: json['DistrictId'],
      name: json['Name'],
    ));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DistrictId'] = this.districtId;
    data['CityId'] = this.cityId;
    data['CityName'] = this.cityName;
    data['Name'] = this.name;
    return data;
  }
}