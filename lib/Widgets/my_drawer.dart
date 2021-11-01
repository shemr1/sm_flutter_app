import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sm_flutter_app/Authentication/login_screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    User user;

    user = FirebaseAuth.instance.currentUser;

    String name = user.displayName;

    String photoUrl = user.photoURL;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 25.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                ),
                Text(
                  (name),
                  style: GoogleFonts.spaceMono(
                    textStyle: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                )
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(children: [
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text(
                  "My Appointments",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushNamed(context, '/appointments'),
              ),
              ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                title: Text(
                  "Appointments Requests",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushNamed(context, '/appointMe'),
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((v) {
                    Route route =
                        MaterialPageRoute(builder: (c) => LoginPage());
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.27,
              ),
              Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     IconButton(onPressed: (){}, icon:Icon(FontAwesomeIcons.question)),
                     IconButton(onPressed: (){}, icon: Icon(Icons.settings)),

                   ],
                 ),
                ),

            ]),
          ),
        ],
      ),
    );
  }
}
