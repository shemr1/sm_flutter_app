import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';

class ServiceEdit extends StatefulWidget {
  final ServiceModel serviceModel;
  ServiceEdit({this.serviceModel, User user});

  @override
  _ServiceEditState createState() => _ServiceEditState();
}

class _ServiceEditState extends State<ServiceEdit> {
  TextEditingController tcon = TextEditingController();
  TextEditingController dcon = TextEditingController();
  TextEditingController pcon = TextEditingController();
  TextEditingController ducon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.serviceModel.thumbnailURL,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: tcon,

                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: widget.serviceModel.title,
                                suffix: IconButton(
                              icon: Icon(Icons.check_outlined),
                              onPressed: () {
                                updateTitle(tcon.text.trim());
                              },
                            )),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: dcon,

                            decoration: InputDecoration(
                              hintText: widget.serviceModel.description,
                                suffix: IconButton(
                              icon: Icon(Icons.check_outlined),
                              onPressed: () {
                                updateDescription(dcon.text.trim());
                              },
                            )),
                            maxLines: 3,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: pcon,
                            keyboardType: TextInputType.number,

                            style: boldTextStyle,
                            decoration: InputDecoration(
                              hintText: r"$" + widget.serviceModel.price.toString(),
                                suffix: IconButton(
                              icon: Icon(Icons.check_outlined),
                              onPressed: () {
                                updatePrice(pcon.toString().trim());
                              },
                            )),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: ducon,
                            keyboardType: TextInputType.number,

                            style: boldTextStyle,
                            decoration: InputDecoration(
                              hintText: widget.serviceModel.duration.toString() + " minutes",
                                suffix: IconButton(
                              icon: Icon(Icons.check_outlined),
                              onPressed: () {
                                updateDuration(ducon.toString().trim());
                              },
                            )),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTitle(String update) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Services');

    await users
        .doc(widget.serviceModel.uid)
        .update({"title": update})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
  }

  Future<void> updateDescription(String update) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Services');

    await users
        .doc(widget.serviceModel.uid)
        .update({"description": update})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
  }

  Future<void> updatePrice(String update) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Services');

    await users
        .doc(widget.serviceModel.uid)
        .update({"price": update})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
  }

  Future<void> updateDuration(String update) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Services');

    await users
        .doc(widget.serviceModel.uid)
        .update({"duration": update})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update: $error"));
  }
}


TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
TextStyle largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
