import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';

import 'package:sm_flutter_app/Business/Screens/CategoryPicked.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:sm_flutter_app/Store/Categories.dart';
import 'package:sm_flutter_app/Store/profile.dart';
import 'package:sm_flutter_app/Store/service_page.dart';
import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';

class Dashboard extends StatefulWidget {
  final LocationData locate;
  Dashboard({this.locate});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var header;
  ServiceModel sm;
  var content;

  LocationData _currentPosition;
  GeoPoint geopoint;
  List list = <Widget>[];

  @override
  @override
  Widget build(BuildContext context) {
    saveToken();
    _currentPosition = widget.locate;
    final Future<QuerySnapshot> _Stream =
        FirebaseFirestore.instance.collection('Services').get();
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
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
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
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
              backgroundColor: Colors.transparent,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchBar());
                    Navigator.push(context, route);
                  },
                  icon: Icon(
                    Icons.search,
                    color: HexColor("ECE7B4"),
                  ),
                )
              ],
            ),
            drawer: MyDrawer(),
            body: Container(
              decoration: BoxDecoration(
                color: HexColor("406343"),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Hi " + auth.currentUser.displayName,
                      style: TextStyle(
                          color:  HexColor("F3EFCC"), fontSize: height * 0.025),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Where to today?",
                      style: TextStyle(
                          color: Colors.white70, fontSize: height * 0.03),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor("F1E9E5"),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Route route = MaterialPageRoute(
                                    //     builder: (c) => Category());
                                    // Navigator.push(context, route);
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Category();
                                        });
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(color: HexColor("5F7A61")),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: height * 0.08,
                              child: GridView(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 300,
                                        childAspectRatio: .75,
                                        mainAxisSpacing: 0),
                                children: [
                                  categoryContainer(
                                    "Automotive",
                                    FontAwesomeIcons.carSide,
                                  ),
                                  categoryContainer(
                                    "Health",
                                    FontAwesomeIcons.heartbeat,
                                  ),
                                  categoryContainer(
                                    "Finance",
                                    FontAwesomeIcons.comments,
                                  ),
                                  categoryContainer(
                                    "Wellness",
                                    FontAwesomeIcons.medkit,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Popular Services",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                        builder: (c) => Profile());
                                    Navigator.push(context, route);
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(color: HexColor("5F7A61")),
                                  ),
                                )
                              ],
                            ),
                          ),
                          FutureBuilder(
                              future: _Stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                return Flexible(
                                    child: GridView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          childAspectRatio: 1.35),
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data();
                                    geopoint = data['geopoint'];
                                    double rs = data['rating'] / data['ratingNum'];
                                    String distanceInMeters =
                                        (Geolocator.distanceBetween(
                                                    geopoint.latitude,
                                                    geopoint.longitude,
                                                    _currentPosition.latitude,
                                                    _currentPosition
                                                        .longitude) /
                                                1000)
                                            .toStringAsFixed(2);

                                    return InkWell(
                                      onTap: () {
                                        sm = ServiceModel(
                                          data['uid'],
                                          data['title'],
                                          data['shortCaption'],
                                          data['date created'],
                                          data['thumbnailURL'],
                                          data['description'],
                                          data['status'],
                                          data['Company'],
                                          data['CompanyUID'],
                                          data['category'],
                                          data['price'],
                                          data['duration'],
                                          data['ReqNum'],
                                          data['AppNum'],
                                          data['geopoint'],
                                          data['rating'],
                                        );

                                        Route route = MaterialPageRoute(
                                            builder: (c) => ServicePage(
                                                  serviceModel: sm,
                                                ));
                                        Navigator.push(context, route);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  height: height * 0.3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              topRight: Radius
                                                                  .circular(5)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(data[
                                                              'thumbnailURL']))),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data['title'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              letterSpacing: .5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: height *
                                                                  0.025),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          WidgetSpan(
                                                            child: Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: height *
                                                                    0.025),
                                                          ),
                                                          TextSpan(
                                                            text: data['price']
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      .5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      height *
                                                                          0.025),
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Text(
                                                    data['description'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        letterSpacing: .5,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          WidgetSpan(
                                                            child: Icon(
                                                                Icons
                                                                    .add_location,
                                                                size: height *
                                                                    0.025),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                distanceInMeters +
                                                                    " km away",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  letterSpacing:
                                                                      .5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      height *
                                                                          0.018),
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                      RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            color:
                                                                Colors.yellow,
                                                          )),
                                                          TextSpan(text: " "),
                                                          TextSpan(
                                                              text: rs.isNaN ==
                                                                      true
                                                                  ? '0'
                                                                  : rs.toStringAsFixed(
                                                                      1),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    height *
                                                                        0.018,
                                                                letterSpacing:
                                                                    .5,
                                                              ))
                                                        ]),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ));
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  categoryContainer(
    String x,
    IconData y,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: HexColor('CEE5D0'),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (builder) => CategoryPicked(
                    cat: x,
                  ));
          Navigator.push(context, route);
        },
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Icon(y,color: HexColor('A09F57'),)),
              Text(x),
            ],
          ),
        ),
      ),
    );
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

    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    // Assume user is logged in for this example

    ds.get().then((snapshot) async => {
          if (snapshot.exists)
            {
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

  Future<void> GetAddressFromLatLong(GeoPoint position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String x =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return x;
  }
}
