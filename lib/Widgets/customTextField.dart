import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  final TextInputType textInputType;
   bool isObscure = true;

  CustomTextField({Key key, this.controller,this.data, this.textInputType, this.hintText,this.isObscure,}):
        super (key:key);


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          // color:Colors.white,
          borderRadius:  BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          keyboardType: textInputType,
          obscureText: isObscure,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon:Icon(
              data,
              color:Theme.of(context).primaryColor ,
            ),
             focusColor:Theme.of(context).primaryColor,
            hintText: hintText,

          ),
        ),
      ),
    );
  }
}

