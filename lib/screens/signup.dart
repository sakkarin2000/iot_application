import 'package:flutter/material.dart';
import 'package:iot_application/providers/applicationstate.dart';
import 'package:iot_application/widgets/button.dart';
import 'package:iot_application/widgets/textformfield.dart';
import 'package:provider/provider.dart';
import 'package:iot_application/screens/monthschedule.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();

  final _displayNameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.only(left: 15, top: 0),
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20,
                color: Colors.white,
                tooltip: 'back',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 48),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'I',
                      style: TextStyle(
                          color: Color(0xFFBED4DF),
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mali'),
                    ),
                    TextSpan(
                      text: 'o',
                      style: TextStyle(
                          color: Color(0xFFCCADA5),
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mali'),
                    ),
                    TextSpan(
                      text: 'T',
                      style: TextStyle(
                          color: Color(0xFFFFB9A3),
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mali'),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: 48)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: StyledInputText(
                        controller: _emailController,
                        hintText: "Email",
                        errorText: "Enter your email address"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: StyledInputText(
                        controller: _displayNameController,
                        hintText: "Name Surname",
                        errorText: "Enter your account name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: StyledInputText(
                        controller: _passwordController,
                        hintText: "Password",
                        isPassword: true,
                        errorText: "Enter your password"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: StyledButton(
                        child: Text('Sign up'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            final email = _emailController.text;
                            final displayName = _displayNameController.text;
                            final password = _passwordController.text;
                            Provider.of<ApplicationState>(context,
                                    listen: false)
                                .signup(email, displayName, password, context);
                          }
                        }),
                  ),
                ],
              ),
            ),
          )
        ]),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/waiting-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
