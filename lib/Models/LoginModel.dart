// List<Datalist> datalist = new List();
// class Datalist {
//   var UserId ;
//  var NAME;
//   var EMAIL;
//   var PASSWORD ;
//   var LOCATION_X;
//   var LOCATION_Y;
//   var AREA;
//
//   Datalist({this.UserId , this.NAME , this.EMAIL , this.PASSWORD , this.LOCATION_X , this.LOCATION_Y , this.AREA});
// }

class LoginModel {
 bool isSuccess;
 ResponseObject responseObject;
 String responseString;
 Null error;
 Null requestedObject;
 Null redirectionUrl;
 Null exception;

 LoginModel(
     {this.isSuccess,
      this.responseObject,
      this.responseString,
      this.error,
      this.requestedObject,
      this.redirectionUrl,
      this.exception});

 LoginModel.fromJson(Map<String, dynamic> json) {
  isSuccess = json['IsSuccess'];
  responseObject = json['ResponseObject'] != null
      ? new ResponseObject.fromJson(json['ResponseObject'])
      : null;
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
   data['ResponseObject'] = this.responseObject.toJson();
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
 int userId;
 String nAME;
 String eMAIL;
 String pASSWORD;
 double lOCATIONX;
 double lOCATIONY;
 String aREA;

 ResponseObject(
     {this.userId,
      this.nAME,
      this.eMAIL,
      this.pASSWORD,
      this.lOCATIONX,
      this.lOCATIONY,
      this.aREA});

 ResponseObject.fromJson(Map<String, dynamic> json) {
  userId = json['UserId'];
  nAME = json['NAME'];
  eMAIL = json['EMAIL'];
  pASSWORD = json['PASSWORD'];
  lOCATIONX = json['LOCATION_X'];
  lOCATIONY = json['LOCATION_Y'];
  aREA = json['AREA'];
 }

 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['UserId'] = this.userId;
  data['NAME'] = this.nAME;
  data['EMAIL'] = this.eMAIL;
  data['PASSWORD'] = this.pASSWORD;
  data['LOCATION_X'] = this.lOCATIONX;
  data['LOCATION_Y'] = this.lOCATIONY;
  data['AREA'] = this.aREA;
  return data;
 }
}