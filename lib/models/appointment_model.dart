import 'package:cloud_firestore/cloud_firestore.dart';


class AppointmentModel {
  String uid;
  String requester;
  String requesterUID;
  String serviceCompany;
  String serviceCompanyUID;
  int duration;
  int price;
  String serviceTitle;
  String serviceUID;
  Timestamp dateRequested;
  String status;
  String appointmentTime;
  String appointmentDate;


  AppointmentModel({
    this.duration,
    this.price,
    this.requesterUID,
    this.serviceCompanyUID,
    this.appointmentTime,
    this.appointmentDate,
    this.dateRequested,
    this.requester,
    this.serviceCompany,
    this.serviceUID,
    this.serviceTitle,
    this.status,
    this.uid,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json){
    serviceTitle = json ['AppointmentService'];
    serviceUID = json['ServiceUID'];
    serviceCompany = json ['Company'];
    serviceCompanyUID = json['CompanyUID'];
    requesterUID = json['CustomerUID'];
    requester = json['Customer'];
    dateRequested = json['DateRequested'];
    appointmentTime = json ['RequestedTime'];
    appointmentDate = json ['RequestedDate'];
    duration = json['Duration'];
    price = json['Price'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Service'] = this.serviceTitle;
    data['Company'] = this.serviceCompany;
    data ['CompanyUID'] = this.serviceCompanyUID;
    data ['Requester'] = this.requester;
    data ['RequestedDate'] = this.appointmentDate;
    data['RequestedTime'] = this.appointmentTime;
    data['Duration'] = this.duration;
    data['Price'] = this.price;
    data['uid'] =  this.uid;
    data['ServiceUID'] = this.serviceUID;

    return data;
  }
}

  class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
  date = json['$date'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['$date'] = this.date;
  return data;
  }
}


