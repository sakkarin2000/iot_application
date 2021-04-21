import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot_application/widgets/hamburger.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String displayName;
  String email;

  @override
  void initState() {
    super.initState();
    showDisplayName();
    showEmail();
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

   Future<void> showEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          email = event.email;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: Hamburgerja(),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 32, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          icon:
                              Icon(Icons.menu, size: 25, color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 280, 10, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Icon(Icons.account_circle_rounded,
                            size: 100.0, color: Colors.grey),
                      ),
                      // Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold )),
                      Container(
                        // color: Colors.red,
                        width: 220,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$displayName',
                                    style: TextStyle(
                                        fontSize: 19, fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Icon(Icons.edit),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text('$email',
                                      style: TextStyle(
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                      ),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/profile-bg.png"),
                fit: BoxFit.cover,
              ),
            )));
  }
}
