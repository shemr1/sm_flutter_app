import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sm_flutter_app/models/service_model.dart';

import '../business_dashboard.dart';
import 'ServiceDetails.dart';

class EditService extends StatefulWidget {
  const EditService({Key key}) : super(key: key);

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final _auth = FirebaseAuth.instance;
  var sCode;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){ Route route = MaterialPageRoute(
              builder: (c) => BusinessDashboard());
          Navigator.pushReplacement(context,route);}
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Services").where('CompanyUID',isEqualTo: _auth.currentUser.uid)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        ServiceModel model = ServiceModel.fromJson(
                            dataSnapshot.data.docs[index].data());
                        return sourceInfo(model, context, _auth.currentUser);
                      },
                      itemCount: dataSnapshot.data.docs.length,
                    );
            },
          )
        ],
      ),
    );
  }


}

sourceInfo(ServiceModel model, BuildContext context, User user,) {


    return Card(

        child: InkWell(
          onTap:()=> serviceDetails(model,context),
          child: ListTile(
            title: Text(model.title),
            subtitle: Text(model.description),
            trailing: Text("\$ " + model.price.toString()),
          ),
        ),

    );



}
void serviceDetails(ServiceModel model, BuildContext context)
{
  final _auth = FirebaseAuth.instance;
  Route route = MaterialPageRoute(builder: (c) => ServiceDetails(serviceModel: model,user: _auth.currentUser,) );
  Navigator.push(context,route);
}




