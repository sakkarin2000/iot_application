import 'package:flutter/material.dart';
import 'package:iot_application/model/authType.dart';
import 'package:iot_application/screens/login.dart';
import 'package:iot_application/screens/signup.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  var authType = AuthType.Login;
  void onChange(type) {
    setState(() {
      authType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return authType == AuthType.Login
        ? LoginPage(
            onChange: () => onChange(AuthType.SignUp),
          )
        : SignupPage(onChange: () => onChange(AuthType.Login));
  }
}
