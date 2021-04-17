import 'package:flutter/material.dart';
import 'package:iot_application/widgets/textformfield.dart';
import 'package:iot_application/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:iot_application/providers/applicationstate.dart';

class LoginPage extends StatefulWidget {
  final onChange;
  LoginPage({this.onChange});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24.0),
          ),
          RichText(
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
                        controller: _passwordController,
                        hintText: "Password",
                        isPassword: true,
                        errorText: "Enter your password"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Create new account ',
                        style: TextStyle(
                            color: Color(0xFFF3DCD7),
                            fontFamily: 'mali',
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () => widget.onChange(),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xFFF3DCD7),
                            fontFamily: 'mali',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: StyledButton(
                        child: Text('Log in'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            Provider.of<ApplicationState>(context,
                                    listen: false)
                                .login(email, password, context);
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
