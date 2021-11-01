import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sm_flutter_app/Search/SearchPage.dart';
import 'package:sm_flutter_app/Store/Categories.dart';
import 'package:sm_flutter_app/Store/profile.dart';
import 'package:sm_flutter_app/Store/service_page.dart';
import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';

class CategoryPicked extends StatefulWidget {
  final String cat;
  CategoryPicked({ this.cat});

  @override
  _CategoryPickedState createState() => _CategoryPickedState();
}

class _CategoryPickedState extends State<CategoryPicked> {
  FirebaseAuth auth = FirebaseAuth.instance;

  ServiceModel sm;
  @override

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage:
                      NetworkImage(auth.currentUser.photoURL),
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
                  color: HexColor("112D4E"),
                ),
              )
            ],
          ),
          drawer: MyDrawer(),
          body: Container(
            decoration: BoxDecoration(
              color: HexColor("464660"),
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
                        color: Colors.white70, fontSize: height * 0.025),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Where to today?",
                    style: TextStyle(
                        color: HexColor("5F7A61"), fontSize: height * 0.03),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                onTap: (){
                                  Route route = MaterialPageRoute(builder: (c) => Category());
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.cat,style: TextStyle(fontSize: height * 0.04),),
                        ),
                        SizedBox(
                          height: height * 0.05,
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
                        StreamBuilder(
                            stream:  FirebaseFirestore.instance.collection('Services').where("category", isEqualTo: widget.cat).snapshots(),
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
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.85),
                                    children: snapshot.data.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data();

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
                                          child: Column(
                                            children: [
                                              Container(
                                                height: height * 0.2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                        topLeft: Radius
                                                            .circular(5),
                                                        topRight:
                                                        Radius.circular(
                                                            5)),
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(data[
                                                        'thumbnailURL']))),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(data['title']),
                                                    SizedBox(
                                                      height: height * 0.04,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              WidgetSpan(
                                                                child: Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    size: 14),
                                                              ),
                                                              TextSpan(
                                                                  text: " " +
                                                                      data['duration']
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              WidgetSpan(
                                                                child: Icon(
                                                                    Icons
                                                                        .attach_money,
                                                                    size: 14),
                                                              ),
                                                              TextSpan(
                                                                  text: "" +
                                                                      data['price']
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
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
    );
  }
}
