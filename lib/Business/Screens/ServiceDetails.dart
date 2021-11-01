import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sm_flutter_app/Widgets/my_drawer.dart';
import 'package:sm_flutter_app/models/service_model.dart';

import 'ServiceEdit.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceModel serviceModel;
  ServiceDetails({this.serviceModel, User user});

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed:() {
                  serviceEdit(widget.serviceModel, context);
      },
                icon: Icon(Icons.edit),),
          ],
        ),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.serviceModel.thumbnailURL,
                          height: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceModel.title +
                                " by " +
                                widget.serviceModel.Company,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.serviceModel.description,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            r"$ " + widget.serviceModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void serviceEdit(ServiceModel model, BuildContext context)
{
  final _auth = FirebaseAuth.instance;
  Route route = MaterialPageRoute(builder: (c) => ServiceEdit(serviceModel: model,user: _auth.currentUser,) );
  Navigator.push(context,route);
}


TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
TextStyle largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);