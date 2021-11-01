import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sm_flutter_app/Authentication/login_screen.dart';


import '../Authentication/business_screen.dart';

class WelcomeChoice extends StatefulWidget {
  @override
  _WelcomeChoiceState createState() => _WelcomeChoiceState();
}

class _WelcomeChoiceState extends State<WelcomeChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/images/splash.jpg'), fit: BoxFit.cover)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage('lib/images/sm.png'),
                    height: 240.0,
                    width: 240.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                         clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.3,0,0,0),
                          tileColor: Colors.orangeAccent,
                          leading: Icon(
                            Icons.person
                          ),
                          title: Text ("Login"),
                          onTap: () {
                            Route route = MaterialPageRoute(builder: (c) => LoginPage());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                       ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          
                          contentPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.3,0,0,0),

                          tileColor: Colors.deepOrangeAccent,
                          leading: Icon(
                              Icons.business
                          ),
                          title: Text ("Register"),

                          onTap: () {
                            Route route = MaterialPageRoute(builder: (c) => WelcomeBusinessScreen());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      )
                    ]),
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                //   RaisedButton.icon(
                //     color: Colors.blueGrey,
                //     icon: Icon(
                //       Icons.person,
                //       size: 50,
                //     ),
                //     onPressed: () {
                //       Route route =
                //           MaterialPageRoute(builder: (c) => WelcomeScreen());
                //       Navigator.pushReplacement(context, route);
                //     },
                //     label: Text("Customer"),
                //   ),
                //   Padding(padding: EdgeInsets.all(25.0)),
                //   RaisedButton.icon(
                //     color: Colors.blueGrey,
                //     icon: Icon(
                //       Icons.business,
                //       size: 50,
                //     ),
                //     onPressed: () {
                //       Route route = MaterialPageRoute(
                //           builder: (c) => WelcomeBusinessScreen());
                //       Navigator.pushReplacement(context, route);
                //     },
                //     label: Text("Business"),
                //   ),
                // ]),
              ],
            ),

        ),
      ),
    );
  }
}
