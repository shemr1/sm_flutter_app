import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_flutter_app/Business/business_dashboard.dart';
import 'package:sm_flutter_app/Widgets/customTextField.dart';

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  TextEditingController _desc = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _short = TextEditingController();
  TextEditingController _time = TextEditingController();

  bool uploading = false;
  final _picker = ImagePicker();
  static String serviceID = DateTime.now().millisecond.toString();
  File file;
  File _imageFile;
  FirebaseAuth auth = FirebaseAuth.instance;
  String holder;
  String dropdown;

  List listItem = [
    'Health',
    'Finance',
    'Wellness',
    'Grooming',
    'Animal Services',
    'Automotive',
    'Hospitality',
    'Educational Services',
    'Food and Drink',
    'Other'
  ];

  var latitude, longitude;



  @override
  Widget build(BuildContext context) {
    getCoords();
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Route route = MaterialPageRoute(
                  builder: (c) => BusinessDashboard());
              Navigator.pop(context,route);
            }),
        title: Text("Add new Service"),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add"),
              onPressed: () => uploadService())
        ],
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Add the image you want to represent the service"),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => selectImage(),
            child: CircleAvatar(
              radius: _screenWidth * 0.15,
              backgroundColor: Colors.white,
              backgroundImage:
                  _imageFile == null ? null : FileImage(_imageFile),
              child: _imageFile == null
                  ? Icon(
                      Icons.add_a_photo,
                      size: _screenWidth * 0.15,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          ListView(shrinkWrap: true, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                width: 250.0,
                child: CustomTextField(
                  controller: _short,
                  data: Icons.article_rounded,
                  hintText: "Short Caption",
                  isObscure: false,
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                width: 250.0,
                child: CustomTextField(
                  controller: _title,
                  data: Icons.article_rounded,
                  hintText: "Service title",
                  isObscure: false,
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                width: 250.0,
                child: CustomTextField(
                  controller: _desc,
                  data: Icons.article_rounded,
                  hintText: "Service description",
                  textInputType: TextInputType.multiline,
                  isObscure: false,
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                width: 250.0,
                child: CustomTextField(
                  controller: _price,
                  data: Icons.article_rounded,
                  hintText: "Service price",
                  textInputType: TextInputType.number,
                  isObscure: false,
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                width: 250.0,
                child: CustomTextField(
                  controller: _time,
                  data: Icons.article_rounded,
                  hintText: "Service duration in minutes",
                  textInputType: TextInputType.number,
                  isObscure: false,
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(
                Icons.business_center,
                color: Colors.lightBlueAccent,
              ),
              title: Container(
                padding: EdgeInsets.all(10.0),
                width: 250.0,
                child: DropdownButton<String>(
                  hint: Text("Service Category"),
                  icon: Icon(Icons.arrow_drop_down_circle),
                  iconEnabledColor: Colors.lightBlueAccent,
                  iconSize: 36.0,
                  isExpanded: true,
                  value: dropdown,
                  onChanged: (value) {
                    setState(() {
                      dropdown = value;
                    });
                  },
                  items: listItem.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
            ),
          ])
        ]),
      ),
    );
  }

  Future<void> capturePhotoCamera() async {
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, maxHeight: 600.0, maxWidth: 970.0);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> pickPhotoGallery() async {
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  selectImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera,
                  color: Colors.lightBlueAccent,
                ),
                title: Text("Capture image with Camera"),
                onTap: () => capturePhotoCamera(),
              ),
              ListTile(
                leading: Icon(
                  Icons.book,
                  color: Colors.lightBlueAccent,
                ),
                title: Text("Choose image from Gallery"),
                onTap: () => pickPhotoGallery(),
              )
            ],
          ));
        });
  }

  clearFormInfo() {
    setState(() {
      _imageFile = null;
      _desc.clear();
      _price.clear();
      _short.clear();
      _title.clear();
      _time.clear();
    });
  }

  uploadService() async {
    String imageDownloadURL = await uploadImage(_imageFile);

    saveServiceInfo(imageDownloadURL);
    Route route = MaterialPageRoute(builder: (c) => BusinessDashboard());
    Navigator.pushReplacement(context, route);
  }

  Future<String> uploadImage(mFIleImage) async {
    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child(("Services"));
    firebase_storage.UploadTask uploadTask =
        storageReference.child("service_$serviceID.jpg").putFile(mFIleImage);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downURL = await taskSnapshot.ref.getDownloadURL();
    return downURL;
  }

  saveServiceInfo(String downloadURL) {
    final serRef = FirebaseFirestore.instance.collection("Services");
    serRef.doc(serviceID).set({
      'uid': serviceID,
      "shortCaption": _short.text.trim(),
      "description": _desc.text.trim(),
      "date created": DateFormat.yMMMMd().format(DateTime.now()),
      "price": int.parse(_price.text),
      "category": dropdown.trim(),
      "thumbnailURL": downloadURL,
      "status": "available",
      "duration": int.parse(_time.text),
      "title": _title.text.trim(),
      "Company": auth.currentUser.displayName.trim(),
      "CompanyUID": auth.currentUser.uid.trim(),
      "ReqNum": 0,
      'AppNum': 0,
      'geopoint': GeoPoint(latitude,longitude),
    });

    setState(() {
      file = null;
      serviceID = DateTime.now().millisecondsSinceEpoch.toString();
      _desc.clear();
      _title.clear();
      _short.clear();
      _price.clear();
      _time.clear();
    });
  }

  getCoords(){
    DocumentReference df = FirebaseFirestore.instance.collection('Businesses').doc(auth.currentUser.uid);

    df.get().then((DocumentSnapshot ds){
      GeoPoint x =ds['geopoint'];

      if(this.mounted){
        setState(() {
          latitude = x.latitude;
          longitude = x.longitude;
        });
      }
    });
  }

}
