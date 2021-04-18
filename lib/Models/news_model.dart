class NewsModel {
  bool isSuccess;
  List<ResponseObject> responseObject;
  String responseString;
  String error;
  String requestedObject;
  String redirectionUrl;
  String exception;

  NewsModel(
      {this.isSuccess,
        this.responseObject,
        this.responseString,
        this.error,
        this.requestedObject,
        this.redirectionUrl,
        this.exception});

  NewsModel.fromJson(Map<String, dynamic> json) {
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
  int alertId;
  String nEWS;
  String aREA;
  String dATE;

  ResponseObject({this.alertId, this.nEWS, this.aREA, this.dATE});

  ResponseObject.fromJson(Map<String, dynamic> json) {
    alertId = json['AlertId'];
    nEWS = json['NEWS'];
    aREA = json['AREA'];
    dATE = json['DATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AlertId'] = this.alertId;
    data['NEWS'] = this.nEWS;
    data['AREA'] = this.aREA;
    data['DATE'] = this.dATE;
    return data;
  }
}