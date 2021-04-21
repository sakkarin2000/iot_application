import 'package:flutter/material.dart';

class StyledInputText extends StatelessWidget {
  final controller;
  final hintText;
  final isName;
  final isPassword;
  final errorText;
  StyledInputText(
      {@required this.controller,
      @required this.hintText,
      this.isPassword = false,
      this.isName = false,
      @required this.errorText});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 18, fontFamily: 'mali'),
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.0),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return errorText;
          }
          if (isName) {
            if ((value.length > 14) && value.isNotEmpty) {
              return "Name must not more than 14 characters";
            }
          }
          if (isPassword) {
            if((value.length < 6) && value.isNotEmpty) {
              return "Password contains at least 6 characters";
            }
          }
          return null;
        },
      );
}
