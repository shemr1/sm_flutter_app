import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:sm_flutter_app/Store/service_page.dart';
import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  ServiceModel sm;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _Stream =
        FirebaseFirestore.instance.collection('Services').snapshots();
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
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
                      backgroundImage: NetworkImage(auth.currentUser.photoURL),
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
                  Route route = MaterialPageRoute(builder: (c) => SearchBar());
                  Navigator.push(context, route);
                },
                icon: Icon(
                  Icons.search,
                  color: HexColor("112D4E"),
                ),
              )
            ],
          ),
          drawer: MyDrawer(),
          body: Container(
            color: HexColor('F1E9E5'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Popular Services',
                    style: TextStyle(
                        fontSize: height * 0.025, color: HexColor("5F7A61")),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                StreamBuilder(
                    stream: _Stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return Flexible(
                          child: GridView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 1.5),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: height * 0.2,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      data['thumbnailURL']))),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data['title'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      letterSpacing: .5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: height * 0.025),
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                        Icons.attach_money,
                                                        size: height * 0.025),
                                                  ),
                                                  TextSpan(
                                                    text: data['price']
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          letterSpacing: .5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              height * 0.025),
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
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                letterSpacing: .5,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ));
                    }),
              ],
            ),
          )),
    );
  }
}
