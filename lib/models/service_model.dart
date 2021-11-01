

import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String uid;
  String title;
  String shortCaption;
  String date;
  String thumbnailURL;
  String description;
  String status;
  String Company;
  String CompanyUID;
  String category;
  int price;
  int duration;
 int ReqNum;
 int AppNum;
 GeoPoint geopoint;
 int rating;

  ServiceModel(
      String uid,
    String title,
    String shortCaption,
    String date,
    String thumbnailURL,
    String description,
    String status,
    String Company,
    String CompanyUID,
    String category,
    int price,
    int duration,
      int ReqNum,
      int AppNum,
      GeoPoint geopoint,
      int rating,

  ) {
    this.Company = Company;
    this.shortCaption = shortCaption;
    this.description = description;
    this.title = title;
    this.thumbnailURL = thumbnailURL;
    this.CompanyUID = CompanyUID;
    this.status = status;
    this.price = price;
    this.duration = duration;
    this.date = date;
    this.category = category;
    this.uid = uid;
    this.ReqNum = ReqNum;
    this.AppNum = AppNum;
   this.geopoint = geopoint;
   this.rating = rating;

  }

  ServiceModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortCaption = json['shortCaption'];
    date = json['date created'];
    thumbnailURL = json['thumbnailURL'];
    description = json['description'];
    status = json['status'];
    price = json['price'];
    duration = json['duration'];
    Company = json['Company'];
    CompanyUID = json['CompanyUID'];
    category = json['category'];
    uid = json['uid'];
    ReqNum = json['ReqNum'];
    AppNum = json['AppNum'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortCaption'] = this.shortCaption;
    data['price'] = this.price;
    if (this.date != null) {
      data['publishedDate'] = this.date;
    }
    data['thumbnailURL'] = this.thumbnailURL;
    data['description'] = this.description;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['Company'] = this.Company;
    data['CompanyUID'] = this.CompanyUID;
    data['uid'] = this.uid;
    data['category'] = this.category;
    data['rating'] = this.rating;
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
