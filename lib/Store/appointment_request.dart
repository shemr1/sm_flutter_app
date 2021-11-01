import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm_flutter_app/models/appointment_model.dart';

class AppointMe extends StatefulWidget {
  @override
  _AppointMeState createState() => _AppointMeState();
}

class _AppointMeState extends State<AppointMe> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      child: SafeArea(
          child:
              Scaffold(
                appBar: AppBar(),
                body: StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection("Customers").
                    doc(FirebaseAuth.instance.currentUser.uid)
                      .collection("Appointment requests")
                      .orderBy(
                    "DateRequested",
                    descending: true,
                  )
                      .snapshots(),
      builder: (context, dataSnapshot) {
      return !dataSnapshot.hasData
      ? Center(
      child: CircularProgressIndicator(),
      )
          :
      ListView.builder(
      itemCount: dataSnapshot.data.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot data = dataSnapshot.data.docs[index];
        AppointmentModel appointmentModel = AppointmentModel(
          uid: data["uid"],
          requester: FirebaseAuth.instance.currentUser.displayName,
          requesterUID: FirebaseAuth.instance.currentUser.uid,
          duration: data["Duration"],
          price: data["Price"],
          serviceCompany: data["Company"],
          serviceCompanyUID: data["CompanyUID"],
          appointmentDate: data["RequestedDate"],
          appointmentTime: data["RequestedTime"],
          serviceTitle: data["AppointmentService"],
          status: data["Status"],
          dateRequested: data["DateRequested"],
        );
        return Container(
          height: height * 0.15,
          child: Card(
            elevation: height * 0.3,
            child: ListTile(
                title: Text(appointmentModel.serviceTitle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointmentModel.appointmentDate + " at "+ appointmentModel.appointmentTime),
                    Text(appointmentModel.status)
                  ],
                ),
                trailing: Text("\$" + appointmentModel.price.toString()),
            ),

          ),
        );
      });

      }, ),
              )
            
          ),
    );

  }
}
