
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sm_flutter_app/Appointment/my_appointments.dart';
import 'package:sm_flutter_app/Business/Screens/Appointment_request.dart';
import 'package:sm_flutter_app/Business/Screens/Business_appointments.dart';
import 'package:sm_flutter_app/Business/Screens/add_service.dart';

import 'package:sm_flutter_app/Business/business_dashboard.dart';
import 'package:sm_flutter_app/Counters/ServiceQuantity.dart';
import 'package:sm_flutter_app/Counters/total_Cost.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:sm_flutter_app/Store/home.dart';
import 'Authentication/login_screen.dart';
import 'Authentication/registration_screen.dart';
import 'Business/Screens/Edit_Service.dart';
import 'Counters/appoint_item_counter.dart';

import 'package:sm_flutter_app/Store/appointment_request.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Store/Dashboard.dart';



const AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await fln
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(ScheduleMe());
}

class ScheduleMe extends StatefulWidget {
  @override
  _ScheduleMeState createState() => _ScheduleMeState();
}

class _ScheduleMeState extends State<ScheduleMe> {
  @override
  LocationData locate;
  bool isCust = false;
   StreamSubscription<User> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        getRoleChoice(FirebaseAuth.instance.currentUser.uid, context);
      }
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        fln.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.lightBlueAccent,
              playSound: true,
              icon: 'mipmap/ic_launcher',
            )));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
  }

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    var x;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => AppointItemCounter(),
        ),
        ChangeNotifierProvider(
          create: (c) => ServiceQuantity(),
        ),
        ChangeNotifierProvider(
          create: (c) => TotalCost(),
        )
      ],
      child: ValueListenableBuilder(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {


            return MaterialApp(


              home: FirebaseAuth.instance.currentUser == null ?   LoginPage() : isCust == true ? Dashboard(locate: locate,) : BusinessDashboard(),
              routes: <String, WidgetBuilder>{

                '/login': (BuildContext context) => LoginPage(),
                '/register': (BuildContext context) => RegistrationScreen(),
                '/dash': (BuildContext context) => Dashboard(),
                '/home': (BuildContext context) => Home(),
                '/appointments': (BuildContext context) => MyAppointments(),
                '/appointMe': (BuildContext context) => AppointMe(),
                '/busdash': (BuildContext context) => BusinessDashboard(),
                '/search':(BuildContext context) => SearchBar(),
                '/addservice':(BuildContext context) =>AddService(),
                '/apprequest':(BuildContext context) => AppRequest(),
                '/busappoints':(BuildContext context) => BusinessAppointments(),
                '/editService':(BuildContext context) => EditService(),
              },
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.teal),
              darkTheme: ThemeData.dark(),
              themeMode: currentMode,
            );
          }),
    );


  }



   getRoleChoice(uid, BuildContext context) async {

    FirebaseFirestore.instance
        .collection('Customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          isCust = true;
        });

      }
    });


      Location location = Location();
      var x = await location.getLocation();
      setState(() {
        locate =  x;
      });




  }
}
