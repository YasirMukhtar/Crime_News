import 'package:crime_news/Global.dart';

class getStateModel {
  bool isSuccess;
  List<ResponseObject> responseObject;
  Null responseString;
  Null error;
  Null requestedObject;
  Null redirectionUrl;
  Null exception;

  getStateModel(
      {this.isSuccess,
      this.responseObject,
      this.responseString,
      this.error,
      this.requestedObject,
      this.redirectionUrl,
      this.exception});

  getStateModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['ResponseObject'] != null) {
      responseObject = new List<ResponseObject>();
      json['ResponseObject'].forEach((v) {
        responseObject.add(new ResponseObject.fromJson(v));
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

class ResponseObject {
  int stateId;
  String name;

  ResponseObject({this.stateId, this.name});

  ResponseObject.fromJson(Map<String, dynamic> json) {
    stateId = json['StateId'];
    name = json['Name'];
      stateList.add(ResponseObject(
        stateId: json['StateId'],
        name: json['Name'],
      ));
    } 


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StateId'] = this.stateId;
    data['Name'] = this.name;
    return data;
  }
}
