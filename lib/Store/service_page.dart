import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:sm_flutter_app/Widgets/customAppBar.dart';
import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ServicePage extends StatefulWidget {
  final ServiceModel serviceModel;
  ServicePage({this.serviceModel, User user});
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  int quantityOfService = 1;
  FirebaseAuth auth = FirebaseAuth.instance;
  String end;
  String s;

  @override
  Widget build(BuildContext context) {
    getClosingTime(widget.serviceModel);
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('lib/images/sm.png'),
                  ),
                ),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor:  HexColor("406343"),
          centerTitle: true,

        ),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(

              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      widget.serviceModel.thumbnailURL,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.serviceModel.title,
                                style: GoogleFonts.ptSans(
                                  fontWeight: FontWeight.bold,
                                      fontSize: screenSize.height * 0.035
                                ),

                              ),
                              Text(
                                r"$ " + widget.serviceModel.price.toString(),
                                style: GoogleFonts.ptSans(
                                  fontSize: screenSize.height * 0.025
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Text(widget.serviceModel.Company,
                            style: TextStyle(
                              fontSize: screenSize.height*0.02,
                              color: HexColor("406343"),
                            )),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.05,
                          ),
                          Text(
                            widget.serviceModel.description,
                            style: GoogleFonts.ptSans(
                              fontSize: screenSize.height * 0.023
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.05,
                          ),



                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () => setAppointmentDateTime(
                            context, widget.serviceModel),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [HexColor('406343'), HexColor('ECE7B4')],
                              begin: const FractionalOffset(1.0, 1.0),
                              end: const FractionalOffset(1.0, 0.0),
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: screenSize.width * 0.6,
                          height: 50.0,
                          child: Center(
                            child: Text("Request Appointment",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(child: Text("Note: Operating hours are between $s and $end")),
          ],
        ),
      ),
    );
  }

  Future<void> getClosingTime(ServiceModel sm) async {
    DocumentReference time =
        FirebaseFirestore.instance.collection('Businesses').doc(sm.CompanyUID);

    await time.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (this.mounted) {
          setState(() {
            s = documentSnapshot['opening'];
            end = documentSnapshot['closing'];
          });
        }
      }
    });
  }

  Future<void> setAppointmentDateTime(
      BuildContext context, ServiceModel sm) async {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
    TimeOfDay _endTime = TimeOfDay(
        hour: int.parse(end.split(":")[0]),
        minute: int.parse(end.split(":")[1]));

    double toDouble(TimeOfDay _startTime) =>
        _startTime.hour + _startTime.minute / 60.0;
    double startCheck = toDouble(_startTime);
    double endCheck = toDouble(_endTime);

    DateTime xDate;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 90)), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      xDate = date;
      DatePicker.showTime12hPicker(context, onChanged: (xate) {
        print('change $xate');
      }, onConfirm: (xate) {
        print('confirm ' + DateFormat.Hm().format(xate).toString());
        if (toDouble(TimeOfDay.fromDateTime(xate)) < startCheck ||
            toDouble(TimeOfDay.fromDateTime(xate)) > endCheck) {
          Fluttertoast.showToast(
              msg: "Appointment time picked is outside of operating hours");
        } else {
          Fluttertoast.showToast(
              msg: "Appointment request sent to " + sm.Company);
          validRequest(sm, xDate, xate);
          Navigator.pop(context);
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void validRequest(ServiceModel sm, DateTime dt, DateTime st) {
    var auth = FirebaseAuth.instance.currentUser;
    String appointmentUID = DateTime.now().millisecond.toString();
    var dtf = DateFormat('yyyy-MM-dd').format(dt);
    var t = DateFormat.Hm().format(st);
    var at = DateTime.parse(dtf + " " + t);

    FirebaseFirestore.instance
        .collection("Services")
        .doc(widget.serviceModel.uid)
        .update({"ReqNum": FieldValue.increment(1)});

    FirebaseFirestore.instance
        .collection("Appointment requests")
        .doc(appointmentUID)
        .set({
      "uid": appointmentUID,
      "CustomerUID": auth.uid,
      "ServiceUID": sm.uid,
      "AppointmentService": sm.title,
      "Company": sm.Company,
      "CompanyUID": sm.CompanyUID,
      "Price": sm.price,
      "Duration": sm.duration,
      "Status": "pending",
      "RequestedDate": dtf,
      "RequestedTime": t,
      "DateRequested": at,
    });

    FirebaseFirestore.instance
        .collection("Customers")
        .doc(auth.uid)
        .collection("Appointment requests")
        .doc(appointmentUID)
        .set({
      "uid": appointmentUID,
      "CustomerUID": auth.uid,
      "ServiceUID": sm.uid,
      "AppointmentService": sm.title,
      "Company": sm.Company,
      "CompanyUID": sm.CompanyUID,
      "Price": sm.price,
      "Duration": sm.duration,
      "Status": "pending",
      "RequestedDate": dtf,
      "RequestedTime": t,
      "DateRequested": at,
    });

    FirebaseFirestore.instance
        .collection("Customer Requests")
        .doc(appointmentUID)
        .set({
      "uid": appointmentUID,
      "CompanyUID": sm.CompanyUID,
      "ServiceUID": sm.uid,
      "AppointmentService": sm.title,
      "Customer": auth.displayName,
      "CustomerUID": auth.uid,
      "Duration": sm.duration,
      "Price": sm.price,
      "CustomerEmail": auth.email,
      "Status": "pending",
      "RequestedDate": dtf,
      "RequestedTime": t,
      "DateRequested": at,
    });

    FirebaseFirestore.instance
        .collection("Businesses")
        .doc(sm.CompanyUID)
        .collection("Customer Requests")
        .doc(appointmentUID)
        .set({
      "uid": appointmentUID,
      "CompanyUID": sm.CompanyUID,
      "ServiceUID": sm.uid,
      "AppointmentService": sm.title,
      "Customer": auth.displayName,
      "CustomerUID": auth.uid,
      "Duration": sm.duration,
      "Price": sm.price,
      "CustomerEmail": auth.email,
      "Status": "pending",
      "RequestedDate": dtf,
      "RequestedTime": t,
      "DateRequested": at,
    });
  }
}

TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
TextStyle largeTextStyle =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
