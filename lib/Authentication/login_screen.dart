import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:sm_flutter_app/Store/Dashboard.dart';
import 'package:sm_flutter_app/Widgets/errorDialog.dart';
import 'package:sm_flutter_app/Widgets/loadingDialog.dart';


LocationData locate;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;


  @override
  Widget build(BuildContext context) {
    getPosition();
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
     body: SingleChildScrollView(
       child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.blueGrey,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
            ),
          ),
          height: _screenHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: _screenHeight * 0.15,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage('lib/images/sm.png'),
                    height: 240.0,
                    width: 240.0,
                  ),
                ),
                Text(
                  "Login to your account",
                  style: TextStyle(
                      fontSize: _screenHeight * 0.02, color: Colors.black38),
                ),
                  TextFormField(
                    controller: _emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(
                          Icons.email,
                        )),
                  ),
                  TextFormField(
                    controller: _passwordTextEditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(
                          Icons.lock,
                        )),
                  ),
                ElevatedButton(
                  onPressed: () {
                    _emailTextEditingController.text.isNotEmpty &&
                            _passwordTextEditingController.text.isNotEmpty
                        ? loginUser()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                  message: ' Please write email and password');
                            });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlueAccent),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 4.0,
                  width: _screenWidth * 0.8,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),

        ),
     ),
    );
  }

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, please  wait...',
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
      getRoleChoice(firebaseUser.uid, context);
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
// may throw error if device is new
    getRoleChoice(firebaseUser.uid, context);
  }

  getPosition() async {
    Location location = Location();
    var x = await location.getLocation();
    setState(() {
      locate =  x;
    });


  }
}

void getRoleChoice(uid, BuildContext context) async {
  FirebaseFirestore.instance
      .collection('Businesses')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/busdash');
    }
  });

  FirebaseFirestore.instance
      .collection('Customers')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard(locate: locate,)));
    }
  });

}

