import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sm_flutter_app/Business/Screens/CategoryPicked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category extends StatefulWidget {
  const Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: Container(
              color: HexColor("F1E9E5"),
              child: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  shrinkWrap: true,
                  children: [
                    ContainerCat(FontAwesomeIcons.heartbeat, "Health"),
                    ContainerCat(FontAwesomeIcons.comments, "Finance"),
                    ContainerCat(FontAwesomeIcons.medkit, "Wellness"),
                    ContainerCat(CupertinoIcons.scissors_alt, "Beauty"),
                    ContainerCat(FontAwesomeIcons.bone, "Animal Grooming"),
                    ContainerCat(FontAwesomeIcons.carSide, "Automotive"),
                    ContainerCat(FontAwesomeIcons.hotel, "Hospitality"),
                    ContainerCat(FontAwesomeIcons.graduationCap, "Educational Services"),
                    ContainerCat(FontAwesomeIcons.utensils, "Food and Drink"),
                    ContainerCat(FontAwesomeIcons.adjust, "Other")
                  ],
                ),
              ),
            ),
          ]))),
    );
  }
  ContainerCat(IconData x, String y) {
    return InkWell(
      onTap:(){
        Route route = MaterialPageRoute(builder: (builder) => CategoryPicked(cat: y,));
        Navigator.push(context, route);
      },
      child: Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration( shape: BoxShape.circle),
                  child: Icon(x),
                ),
                Text(y),
              ])),
    );
  }
}


