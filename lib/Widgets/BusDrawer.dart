import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sm_flutter_app/Authentication/login_screen.dart';


class BusDrawer extends StatefulWidget {
  const BusDrawer({Key key}) : super(key: key);

  @override
  _BusDrawerState createState() => _BusDrawerState();
}

class _BusDrawerState extends State<BusDrawer> {



  User user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {

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
                colors: [Colors.blueGrey, Colors.blueAccent],
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
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(photoUrl),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
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
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.blueAccent],
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
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
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
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
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

              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                title: Text(
                  "Add new contact",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushNamed(context, '/addcont'),
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
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
                    Route route = MaterialPageRoute(builder: (c) => LoginPage());
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.white,
                thickness: 6.0,
              ),

            ]),
          ),
        ],
      ),
    );
  }
}
