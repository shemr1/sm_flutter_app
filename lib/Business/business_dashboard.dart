import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:hexcolor/hexcolor.dart';

final _auth = FirebaseAuth.instance;

class BusinessDashboard extends StatefulWidget {
  @override
  _BusinessDashboardState createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  int count, rcount;
  CalendarController _controller = CalendarController();
  var s, end, meet;
  TimeOfDay stime = TimeOfDay.now(), etime = TimeOfDay.now();


  @override
  Widget build(BuildContext context) {
    checkforPast();
    saveToken();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    getNum();
    getClosingTime();
    getMeetings();
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes, exit'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [HexColor("003638"), HexColor("F3F2C9")])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                onPressed:(){
                  Route route = MaterialPageRoute(builder: (c) => SearchBar());
                  Navigator.push(context, route);},
                icon: Icon(
                  Icons.search,
                  color: HexColor("112D4E"),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "Hello, ",
                    style: TextStyle(fontSize: height * 0.025),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    _auth.currentUser.displayName,
                    style: TextStyle(
                        fontSize: height * 0.035, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Appointments:",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                )),
                            Text(
                              count == null ? "0" : count.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.025),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Appointment Request:",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: height * 0.02,
                                )),
                            Text(
                              rcount == null ? "0" : rcount.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.025),
                            ),
                          ],
                        )
                      ],
                    ),
                    width: width * 0.95,
                    height: height * 0.15,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage("lib/images/Back.png"),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: (itemWidth / itemHeight) * 6,
                    crossAxisCount: 2,
                    children: [
                      cardTap(FontAwesomeIcons.addressBook, "Add Service", "/addservice",
                          context),
                      cardTap(
                          FontAwesomeIcons.rProject, "Requests", "/apprequest", context),
                      cardTap(
                          FontAwesomeIcons.book, "Appointments", "/busappoints", context),
                      cardTap(
                          FontAwesomeIcons.edit, "Edit Services", "/editService", context)
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Upcoming"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text("See all"),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: height * 0.32,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                      child: SfCalendar(
                    backgroundColor: HexColor("F7F3E9"),
                    controller: _controller,
                    allowViewNavigation: true,
                    cellEndPadding: height * 0.02,
                    allowedViews: [
                      CalendarView.day,
                      CalendarView.week,
                      CalendarView.month,
                    ],
                    onTap: calendarTapped,
                    view: CalendarView.month,
                    monthViewSettings: MonthViewSettings(showAgenda: true),
                    dataSource: MeetingDataSource(_getDataSource()),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: stime.hour.toDouble(),
                      endHour: etime.hour.toDouble(),
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    } else if (_controller.view == CalendarView.day) {
      _controller.view = CalendarView.month;
    }
  }

  getMeetings() async {
    final List<Meeting> meetings = <Meeting>[];

    var z;
    DateTime x;
    int c;
    await FirebaseFirestore.instance
        .collection("Businesses")
        .doc(_auth.currentUser.uid)
        .collection("Appointments")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        z = doc.data()["AppointmentService"];
        x = DateTime.fromMicrosecondsSinceEpoch(
            doc.data()['DateRequested'].microsecondsSinceEpoch);
        c = doc.data()['Duration'];

        meetings.add(Meeting(
            z, x, x.add(Duration(minutes: c)), const Color(0xFF0F8644), false));
      });
    });

    if (this.mounted)
      setState(() {
        meet = meetings;
      });
    return meetings;
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];
    meetings = meet;

    return meetings;
  }

  Future<void> getClosingTime() async {
    DocumentReference time = FirebaseFirestore.instance
        .collection('Businesses')
        .doc(_auth.currentUser.uid);

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

    getTime();
  }

  getTime() {
    if (mounted) {
      setState(() {
        stime = TimeOfDay(
            hour: int.parse(s.split(":")[0]),
            minute: int.parse(s.split(":")[1]));
        etime = TimeOfDay(
            hour: int.parse(end.split(":")[0]),
            minute: int.parse(end.split(":")[1]));
      });
    }
  }

  void getNum() async {
    var x = await FirebaseFirestore.instance
        .collection('Businesses')
        .doc(_auth.currentUser.uid)
        .collection("Appointments")
        .get()
        .then((snapshot) => snapshot.docs.length);

    var y = await FirebaseFirestore.instance
        .collection('Customer Requests')
        .where('CompanyUID', isEqualTo: _auth.currentUser.uid)
        .get()
        .then((snapshot) => snapshot.docs.length);

    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        count = x;
        rcount = y;
      });
    }
  }
}

cardTap(IconData a, String x, String route, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Card(
    color: HexColor("F7F3E9"),
    child: SizedBox(
      height: height * 0.2,
      width: width * 0.4,
      child: ListTile(
        leading: FaIcon(a),
        title: Text(x),
        onTap: () => Navigator.pushNamed(context, route))
          ,
    ),
  );
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

checkforPast(){
  User auth = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Businesses').doc(auth.uid).collection("Appointments");

  users.get().then((snapshots) => {
      snapshots.docs.forEach((doc) {
        if(DateTime.fromMicrosecondsSinceEpoch(doc['DateRequested'].microsecondsSinceEpoch).isBefore(DateTime.now())){
          print(doc.data());
          FirebaseFirestore.instance.collection("Businesses").doc(auth.uid).collection("PassAppointments").doc(doc['uid']).set(
              {
                'uid': doc['uid'],
                'Price': doc['Price'],
                'Customer': doc['Customer'],
                'Duration': doc['Duration'],
                'DateRequested': doc['DateRequested'],
                'Service': doc['AppointmentService'],
              });
          doc.reference.delete();

        }
      })
  });
}

saveToken() async {
  String token = await FirebaseMessaging.instance.getToken();

  // Save the initial token to the database
  await saveTokenToDatabase(token);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

Future<void> saveTokenToDatabase(String token) async {
  String userId = FirebaseAuth.instance.currentUser.uid;

  DocumentReference ds = FirebaseFirestore.instance
      .collection('Users')
      .doc(userId);
  // Assume user is logged in for this example

  ds.get().then((snapshot) async => {
    if(snapshot.exists){
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({
        'tokens': FieldValue.arrayUnion([token]),
      })
    }
    else
      {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .set({
          'tokens': FieldValue.arrayUnion([token]),
        })
      }
  });

}
