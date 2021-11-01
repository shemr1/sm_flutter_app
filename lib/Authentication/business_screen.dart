import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sm_flutter_app/Authentication/registration_screen.dart';

import 'business_registration.dart';

class WelcomeBusinessScreen extends StatefulWidget {
  @override
  _WelcomeBusinessScreenState createState() => _WelcomeBusinessScreenState();
}

class _WelcomeBusinessScreenState extends State<WelcomeBusinessScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Colors.blueGrey],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            'Schedule Me',
            style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lock, color: Colors.white), text: "Customer"),
              Tab(
                icon: Icon(Icons.perm_contact_calendar, color: Colors.white),
                text: "Company",
              )
            ],
            indicatorColor: Colors.white30,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.blueGrey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
            ),
          ),
          child: TabBarView(
              children:
              [
                RegistrationScreen(),
                BusinessRegistrationScreen(),
              ]
          ),
        ),
      ),
    );
  }
}
