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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(Icons.account_circle,
                          size: 75.0, color: Colors.white),
                    ),
                    Text('$displayName',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
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
          CustomListTile(Icons.settings, 'Change password', () => {}),
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
