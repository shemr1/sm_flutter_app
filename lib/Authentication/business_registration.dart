import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'package:sm_flutter_app/Business/business_dashboard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import "dart:io";
import 'dart:async';
import 'package:sm_flutter_app/Widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_flutter_app/Widgets/errorDialog.dart';
import 'package:sm_flutter_app/Widgets/loadingDialog.dart';
import 'package:sm_flutter_app/models/ApiKey.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  @override
  _BusinessRegistrationScreenState createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _confirmTextEditingController =
      TextEditingController();
  final TextEditingController _contactTextEditingController =
      TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File file;
  File _imageFile;
  final _picker = ImagePicker();
  static String imageFileName = DateTime.now().millisecond.toString();
  static TimeRange _result;
  final kInitialPosition = LatLng(-33.8567844, 151.213108);
  PickResult selectedPlace;
  String address;
  final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref(imageFileName);

  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  List scom;

  double latitude;

  double longitude;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10.0),
              InkWell(
                onTap: () => _selectAndPickImage(context),
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
              SizedBox(height: 24.0),
              Form(
                key: _formKey,
                child: Column(children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.business,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObscure: true,
                  ),
                  CustomTextField(
                    controller: _confirmTextEditingController,
                    data: Icons.lock,
                    hintText: "Confirm Password",
                    isObscure: true,
                  ),
                  CustomTextField(
                    controller: _contactTextEditingController,
                    data: Icons.phone,
                    textInputType: TextInputType.phone,
                    hintText: "Enter contact number",
                    isObscure: true,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          apiKey: ApiKey.googleMapApiKey,
                          useCurrentLocation: true,
                          selectInitialPosition: true, // Put YOUR OWN KEY here.
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },

                          initialPosition: kInitialPosition,
                          forceSearchOnZoomChanged: true,
                          automaticallyImplyAppBarLeading: false,

                          selectedPlaceWidgetBuilder:
                              (_, selectedPlace, state, isSearchBarFocused) {
                            print(
                                "state: $state, isSearchBarFocused: $isSearchBarFocused");
                            return isSearchBarFocused
                                ? Container()
                                : FloatingCard(
                                    bottomPosition:
                                        0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                    leftPosition: 0.0,
                                    rightPosition: 0.0,
                                    width: 500,
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: state == SearchingState.Searching
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            child: Text("Pick Here"),
                                            onPressed: () async {
                                              print(selectedPlace.id);

                                              setState(() {
                                                scom = selectedPlace
                                                    .addressComponents;
                                                address = selectedPlace
                                                    .formattedAddress;
                                              });
                                              List<Location> locations =
                                                  await locationFromAddress(
                                                      address);

                                              setState(() {
                                                latitude = locations[0].latitude;
                                                longitude =
                                                    locations[0].longitude;
                                              });

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                  );
                          },
                          pinBuilder: (context, state) {
                            if (state == PinState.Idle) {
                              return Icon(Icons.favorite_border);
                            } else {
                              return Icon(Icons.favorite);
                            }
                          },
                        ),
                      ),
                    ),
                    child: address == null
                        ? Text("Select Business Location")
                        : Text(address ?? ""),
                  ),
                  ElevatedButton(
                    onPressed: () => getbusinessHours(),
                    child: Text("Enter Business Hour range"),
                  ),
                ]),
              ),
              ElevatedButton(
                onPressed: () => uploadAndSaveImage(),
                
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 4.0,
                width: _screenWidth * 0.8,
                // color: Colors.blueGrey,
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectAndPickImage(xContext) {
    showModalBottomSheet(
        context: xContext,
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

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "Please select an image file,");
          });
    } else {
      _passwordTextEditingController.text == _confirmTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _confirmTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty &&
                  _contactTextEditingController.text.isNotEmpty &&
                  address.isNotEmpty &&
                  _result.toString().isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill out the complete form")
          : displayDialog("Passwords do not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering, please wait......",
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref("Businesses");

    firebase_storage.UploadTask storageUploadTask = storageReference
        .child("Businesses$imageFileName.jpg")
        .putFile(_imageFile);

    firebase_storage.TaskSnapshot taskSnapshot = await storageUploadTask;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerBusiness();
    });
  }

  void getbusinessHours() async {
    _result = await showTimeRangePicker(
      use24HourFormat: false,
      context: context,
      paintingStyle: PaintingStyle.fill,
      backgroundColor: Colors.grey.withOpacity(0.2),
      labels: [
        ClockLabel.fromTime(
            time: TimeOfDay(hour: 0, minute: 0), text: "Initial"),
        ClockLabel.fromTime(time: TimeOfDay(hour: 23, minute: 59), text: "End")
      ],
      start: TimeOfDay(hour: 12, minute: 0),
      end: TimeOfDay(hour: 13, minute: 0),
      ticks: 8,
      strokeColor: Theme.of(context).primaryColor.withOpacity(0.5),
      ticksColor: Theme.of(context).primaryColor,
      labelOffset: 15,
      padding: 60,
      disabledColor: Colors.lightBlueAccent.withOpacity(0.5),
    );
  }

  Future<void> _registerBusiness() async {
    User firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
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
    if (firebaseUser != null) {
      saveBusinessInfoToFirestore(firebaseUser).then((value) {
        Route route = MaterialPageRoute(builder: (c) => BusinessDashboard());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future<void> saveBusinessInfoToFirestore(User user) async {
    var now = DateTime.now();
    var xs = DateTime(now.year, now.month, now.day, _result.startTime.hour,
        _result.startTime.minute);
    var xe = DateTime(now.year, now.month, now.day, _result.endTime.hour,
        _result.endTime.minute);
    print(DateFormat('kk:mm').format(xs));

    await FirebaseFirestore.instance
        .collection("Businesses")
        .doc(user.uid)
        .set({
      "uid": user.uid,
      "email": user.email,
      "name": _nameTextEditingController.text.trim(),
      "contact": int.parse(_contactTextEditingController.text),
      "address": address,
      'geopoint': GeoPoint(latitude,longitude),
      "opening": DateFormat('kk:mm').format(xs),
      "closing": DateFormat('kk:mm').format(xe),
      "url": userImageUrl,
      "role": "business",
    });
    String name = _nameTextEditingController.text.trim();
    var url = userImageUrl;
    await user.updateProfile(displayName: name, photoURL: url);
    _saveDeviceToken();
  }

  _saveDeviceToken() async {
    User user = FirebaseAuth.instance.currentUser;
    String fcmToken = await fcm.getToken();

    if (fcm != null) {
      var tokenRef = db
          .collection("Users")
          .doc(user.uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }
}
