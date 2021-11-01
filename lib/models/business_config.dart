
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class BusinessModel {
  String address;
  TimeOfDay opening;
  TimeOfDay closing;
  int contact;
  GeoPoint geopoint;
  String email;
  String name;
  String uid;
  String url;

  BusinessModel(String address, TimeOfDay opening, TimeOfDay closing, int contact,String email,
      String name, String uid,GeoPoint geopoint){
    this.uid = uid;
    this.name = name;
    this.email = email;
    this.contact =contact;
    this.address = address;
    this.closing = closing;
    this.opening = opening;
    this.url = url;
    this.geopoint = geopoint;
  }


  BusinessModel.fromJson(Map<String, dynamic> json){
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    address = json['address'];
    closing = json['closing'];
    opening = json['opening'];
    geopoint = json['geopoint'];
    url = json['url'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name']=this.name;
    data['email']=this.email;
    data['contact']=this.contact;
    data['address']=this.address;
    data['opening']=this.opening;
    data['closing']=this.closing;
    data['geopoint']=this.geopoint;
    data['url'] =this.url;

    return data;
  }
}