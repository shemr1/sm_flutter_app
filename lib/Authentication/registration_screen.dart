import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:sm_flutter_app/Store/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import "dart:io";
import 'dart:async';
import 'package:sm_flutter_app/Widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_flutter_app/Widgets/errorDialog.dart';
import 'package:sm_flutter_app/Widgets/loadingDialog.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _dobTextEditingController =
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
  File _imageFile;
  final _picker = ImagePicker();
  static String imageFileName = DateTime.now().millisecond.toString();

  final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref(imageFileName);

  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

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
                onTap: () => _selectAndPickImage(),
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
                    data: Icons.person,
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
                    controller: _contactTextEditingController,
                    data: Icons.phone,
                    textInputType: TextInputType.phone,
                    hintText: "Contact number",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _dobTextEditingController,
                    data: Icons.calendar_today_outlined,
                    textInputType: TextInputType.datetime,
                    hintText: "Date of Birth (yyyy-dd-mm)",
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
                color: Colors.blueAccent,
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

  Future<void> _selectAndPickImage() async {
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
                  _contactTextEditingController.text.isNotEmpty &&
                  _dobTextEditingController.text.isNotEmpty &&
                  _confirmTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty
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
        firebase_storage.FirebaseStorage.instance.ref().child("Customers");

    firebase_storage.UploadTask storageUploadTask = storageReference
        .child("Customer$imageFileName.jpg")
        .putFile(_imageFile);

    firebase_storage.TaskSnapshot taskSnapshot = await storageUploadTask;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  void _registerUser() async {
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
      saveUserInfoToFirestore(firebaseUser).then((value) {
        Route route = MaterialPageRoute(builder: (c) => Dashboard());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future<void> saveUserInfoToFirestore(User user) async {
    _saveDeviceToken();
    await FirebaseFirestore.instance.collection("Customers").doc(user.uid).set({
      "uid": user.uid,
      "email": user.email,
      'contact': int.parse(_contactTextEditingController.text),
      "name": _nameTextEditingController.text.trim(),
      "date of birth": _dobTextEditingController.text,
      "url": userImageUrl,
      "role": "customer",
    });

    String name = _nameTextEditingController.text.trim();
    var url = userImageUrl;
    await user.updateProfile(displayName: name, photoURL: url);
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
