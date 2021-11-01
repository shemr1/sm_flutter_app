import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sm_flutter_app/Widgets/customTextField.dart';

import 'package:sm_flutter_app/models/appointment_model.dart';

import '../business_dashboard.dart';

final _auth = FirebaseAuth.instance;

class AppRequest extends StatefulWidget {
  @override
  _AppRequestState createState() => _AppRequestState();
}

class _AppRequestState extends State<AppRequest> {
  String role;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => BusinessDashboard());
              Navigator.pushReplacement(context, route);
            }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.blueAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          _auth.currentUser.displayName,
          style: GoogleFonts.kaushanScript(
            textStyle: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Businesses")
                .doc(_auth.currentUser.uid)
                .collection("Customer Requests")
                .where('CompanyUID', isEqualTo: _auth.currentUser.uid)
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
    ));
  }

  Widget sourceInfo(AppointmentModel model, BuildContext context, User user,
      {Color background, removeRequestFunction}) {
    getUrl(model.requesterUID);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(role),
                      minRadius: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(model.requester)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Service: " + model.serviceTitle),
                    Text("Date: " + model.appointmentDate),
                    Text("Time: " + model.appointmentTime),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => acceptRequest(model),
                          child: Text("Accept"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => rejectRequest(model, context),
                          child: Text("Reject"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUrl(String uid) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Customers');
    DocumentSnapshot snapshot = await users.doc(uid).get();
    var data = snapshot.data();

    if (this.mounted) {
      setState(() {
        role = data['url'];
      });
    }
  }
}

acceptRequest(
  AppointmentModel model,
) {

  FirebaseFirestore.instance.collection('Services').doc(model.serviceUID).update(
      {'AppNum': FieldValue.increment(1) });
  FirebaseFirestore.instance
      .collection("Businesses")
      .doc(_auth.currentUser.uid)
      .collection("Appointments")
      .doc(model.uid)
      .set({
    "uid": model.uid,
    "Customer": model.requester,
    "AppointmentService": model.serviceTitle,
    "Price": model.price,
    "Duration": model.duration,
    "DateRequested": model.dateRequested,
    "Status": "Accepted",
  });

  FirebaseFirestore.instance.collection("Appointments").doc(model.uid).set({
    "uid": model.uid,
    "Customer": model.requester,
    "AppointmentService": model.serviceTitle,
    "Price": model.price,
    "Duration": model.duration,
    "DateRequested": model.dateRequested,
    "Status": "Accepted",
  });

  FirebaseFirestore.instance
      .collection("Customers")
      .doc(model.requesterUID)
      .collection("Appointments")
      .doc(model.uid)
      .set({
    "uid": model.uid,
    "Customer": model.requester,
    "AppointmentService": model.serviceTitle,
    "Price": model.price,
    "Duration": model.duration,
    "DateRequested": model.dateRequested,
    "Status": "Accepted",
  });

  FirebaseFirestore.instance.collection("Appointments").doc(model.uid).set({
    "uid": model.uid,
    "Customer": model.requester,
    "CustomerUID": model.requesterUID,
    "CompanyUID": model.serviceCompanyUID,
    "Company": model.serviceCompany,
    "AppointmentService": model.serviceTitle,
    "Price": model.price,
    "Duration": model.duration,
    "DateRequested": model.dateRequested,
    "Status": "Accepted",
  });

  FirebaseFirestore.instance
      .collection("Businesses")
      .doc(_auth.currentUser.uid)
      .collection("Customer Requests")
      .doc(model.uid)
      .delete();

  FirebaseFirestore.instance
      .collection("Customer Requests")
      .doc(model.uid)
      .delete();

  FirebaseFirestore.instance
      .collection("Customers")
      .doc(model.requesterUID)
      .collection("Appointment requests")
      .doc(model.uid)
      .delete();

  FirebaseFirestore.instance
      .collection("Appointment requests")
      .doc(model.uid)
      .delete();
}

rejectRequest(AppointmentModel model, BuildContext x) {
  final TextEditingController _reason = TextEditingController();
  showModalBottomSheet(
      context: x,
      builder: (x) {
        return Column(
          children: [
            CustomTextField(
              isObscure: false,
              controller: _reason,
              data: Icons.message,
              textInputType: TextInputType.multiline,
              hintText: "State the reason for rejection",
            ),
            TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Businesses")
                      .doc(model.serviceCompanyUID)
                      .collection("Customer Requests")
                      .doc(model.uid)
                      .delete();
                  FirebaseFirestore.instance
                      .collection("Customer Requests")
                      .doc(model.uid)
                      .delete();
                  FirebaseFirestore.instance
                      .collection("Appointment requests")
                      .doc(model.uid)
                      .delete();
                  FirebaseFirestore.instance
                      .collection("Customer")
                      .doc(model.requesterUID)
                      .collection("Appointment requests")
                      .doc(model.uid)
                      .update({
                    "Status": "Rejected",
                    "Reason": _reason.text.trim(),
                  });
                },
                child: Text("Confirm"))
          ],
        );
      });
}
