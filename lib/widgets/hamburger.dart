import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iot_application/providers/applicationstate.dart';
import 'package:iot_application/screens/monthschedule.dart';
import 'package:iot_application/screens/categories.dart';
import 'package:iot_application/screens/profile.dart';

void main() => runApp(MyApp());

const primaryColor = Color(0xFF6CAF97);

class MyApp extends StatelessWidget {
  final appTitle = 'Hamburger Bar';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: Hamburgerja(title: appTitle),
    );
  }
}

class Hamburgerja extends StatefulWidget {
  final String title;

  Hamburgerja({Key key, this.title}) : super(key: key);

  @override
  _HamburgerjaState createState() => _HamburgerjaState();
}

class _HamburgerjaState extends State<Hamburgerja> {
  get isSelected => null;
  String displayName;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    showDisplayName();
  }

  Future<void> showDisplayName() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          displayName = event.displayName;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     colors: <Color>[Color(0xff153970), Color(0xff153970)]),
                  color: Color(0xFF153970)),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("images/profile.png"),
                            )),
                      ),
                    ),
                    Text('$displayName',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          CustomListTile(
              Icons.account_box,
              'Profile',
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    )
                  }),
          CustomListTile(
              Icons.calendar_today,
              'My Schedule',
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonthSchedule()),
                    )
                  }),
          CustomListTile(
              Icons.category,
              'Categories',
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CatPageKa()),
                    )
                  }),
          // CustomListTile(Icons.report, 'Report Problem', () => {}),
          CustomListTile(
              Icons.settings,
              'Change password',
              () => {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: ListTile(
                          title: Center(
                            child: Text(
                              'Change password',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Old password',
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please input your old password";
                                        }
                                        if ((value.length < 6) &&
                                            value.isNotEmpty) {
                                          return "Password contains at least 6 characters";
                                        }
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'New password',
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please input your new password";
                                        }
                                        if ((value.length < 6) &&
                                            value.isNotEmpty) {
                                          return "Password contains at least 6 characters";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFE17262),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    5.0))),
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
                                  onPressed: () async {
                                    // if (_formKey.currentState.validate()) {
                                    //   await Firebase.initializeApp()
                                    //       .then((value) async {
                                    //     await FirebaseAuth.instance
                                    //         .authStateChanges()
                                    //         .listen((event) async {
                                    //       event
                                    //           .updatePassword(password: password)
                                    //           .then((value) {
                                    //         findDisplayName();
                                    //         Navigator.pop(context);
                                    //       });
                                    //     });
                                    //   });
                                    // }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFE17262),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0))),
                                  child: Text(
                                    'Save',
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
                    )
                  }),
          CustomListTile(
              Icons.logout,
              'Logout',
              () => {
                    Provider.of<ApplicationState>(context, listen: false)
                        .logout()
                  }),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Color(0xffBED4DF),
        onTap: onTap,
        child: Container(
          height: 63,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(text,
                      style: TextStyle(color: Color(0xff153970), fontSize: 18)),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
