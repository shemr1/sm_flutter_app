import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BusApps extends StatefulWidget {
  const BusApps({Key key}) : super(key: key);

  @override
  _BusAppsState createState() => _BusAppsState();
}

class _BusAppsState extends State<BusApps> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                //do what you want here
              },
              child: CircleAvatar(
                radius: 55.0,
                backgroundImage: NetworkImage(_auth.currentUser.photoURL),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: HexColor("112D4E"),
              ),
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }
}
