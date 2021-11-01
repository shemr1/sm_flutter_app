import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sm_flutter_app/models/appointment_model.dart';
import 'package:rating_dialog/rating_dialog.dart';

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Customers")
            .doc(_auth.currentUser.uid)
            .collection("Appointments")
            .snapshots(),
        builder: (context, dataSnapshot) {
          return !dataSnapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  itemBuilder: (context, index) {
                    AppointmentModel model = AppointmentModel.fromJson(
                        dataSnapshot.data.docs[index].data());
                    return sourceInfo(model, context, _auth.currentUser);
                  },
                  itemCount: dataSnapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4,
                      mainAxisSpacing: 2),
                );
        },
      )),
    );
  }

  Widget sourceInfo(AppointmentModel model, BuildContext context, User user,
      {Color background, removeRequestFunction}) {
    DateTime dt;
    return Card(
      child: ListTile(
        onTap: () => {
          dt = model.dateRequested.toDate(),
          if (dt.isBefore(DateTime.now())) {
            Tap(model)
          }
        },
        title: Text(model.serviceTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Text("Date: " +
                DateFormat('dd-MM-yyyy').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        model.dateRequested.microsecondsSinceEpoch))),
            Text("Time: " +
                DateFormat('kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(
                    model.dateRequested.microsecondsSinceEpoch)))
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration: " + model.duration.toString() + " minutes"),
          ],
        ),
      ),
    );
  }
}

Tap(AppointmentModel model) {
  final _dialog = RatingDialog(
    // your app's name?
    title: model.serviceTitle,
    // encourage your user to leave a high rating?
    message:
        'Tap a star to set your rating. Add more description here if you want.',
    // your app's logo?
    image: const FlutterLogo(size: 100),
    submitButton: 'Submit',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');
      FirebaseFirestore.instance
          .collection('Services')
          .doc(model.serviceUID)
          .update({'rating': FieldValue.increment(response.rating),
      'ratingNum': FieldValue.increment(1)});
      FirebaseFirestore.instance
          .collection('Services')
          .doc(model.serviceUID)
          .collection("Comments")
          .add({
        'Comment': response.comment.trim(),
        'User': FirebaseAuth.instance.currentUser.displayName.trim()
      });
    },
  );
  return _dialog;
}
