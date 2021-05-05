import 'package:flutter/material.dart';
import 'package:iot_application/widgets/textformfield.dart';
import 'package:iot_application/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:iot_application/providers/applicationstate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final onChange;
  LoginPage({this.onChange});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
String _email;
  final auth = FirebaseAuth.instance;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override

void openDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Center(
            child: Text(
              'Forgot password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
               child: TextField(
                 keyboardType: TextInputType.emailAddress,
                 decoration: InputDecoration(hintText: ('Email')),
                 onChanged: (value) {
                   setState(() {
                     _email = value;
                   });
                 },    
               )
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(103, 30),
                        primary: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0))),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                ElevatedButton(
                  onPressed: () {
                    auth.sendPasswordResetEmail(email: _email);
                    Navigator.of(context).pop();
                    print("Password for reset is sent");
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(103, 30),
                      primary: Color(0xFFE17262),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0))),
                  child: Text(
                    'Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                      
                      GestureDetector(
                        onTap: () => openDialog(),
                        child: Text(
                          'Forgot password?',
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
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            fontSize: 18,
                            color: Color(0xFFF3DCD7),
                            fontFamily: 'mali',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
