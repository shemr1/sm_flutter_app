import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sm_flutter_app/models/appointment_model.dart';

import '../business_dashboard.dart';

class BusinessAppointments extends StatefulWidget {
  @override
  _BusinessAppointmentsState createState() => _BusinessAppointmentsState();
}

class _BusinessAppointmentsState extends State<BusinessAppointments> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: (){
            Route route = MaterialPageRoute(
                builder: (c) => BusinessDashboard());
            Navigator.pushReplacement(context,route);
          },),
        ),
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Businesses")
                  .doc(_auth.currentUser.uid)
                  .collection("Appointments")
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                        child: CircularProgressIndicator(),
                      ))
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          AppointmentModel model = AppointmentModel.fromJson(
                              dataSnapshot.data.docs[index].data());
                          return sourceInfo(model, context, _auth.currentUser);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(AppointmentModel model, BuildContext context, User user,
    {Color background, removeRequestFunction}) {
  return Card(
    child: ListTile(
      subtitle: Text(model.serviceTitle),
      title: Text(model.requester),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        Text(DateFormat('dd-MM-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(model.dateRequested.microsecondsSinceEpoch))
            .toString()),
            Text(DateFormat('kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(model.dateRequested.microsecondsSinceEpoch)).toString())
          ]),
      
      trailing: Text("\$ " + model.price.toString()),
    ),
  );
}
