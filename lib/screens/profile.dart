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
  final _formKey = GlobalKey<FormState>();
  String displayName;
  String email;

  @override
  void initState() {
    super.initState();
    showDisplayName();
    showEmail();
    findDisplayName();
  }

  Future<void> findDisplayName() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        displayName = event.displayName;
      });
    });
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

  Future<void> editThread() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                title: Center(
                    child: Text(
                  'Edit Display Name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                subtitle: Center(child: Text('Fill in new display name')),
              ),
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (value) => displayName = value.trim(),
                        initialValue: displayName,
                        autofocus: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_box_outlined),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please input new display name";
                          }
                          if ((value.length > 14) && value.isNotEmpty) {
                            return "Not more than 14 characters";
                          }
                          return null;
                        },
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          )),
                      TextButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await Firebase.initializeApp()
                                  .then((value) async {
                                await FirebaseAuth.instance
                                    .authStateChanges()
                                    .listen((event) async {
                                  event
                                      .updateProfile(displayName: displayName)
                                      .then((value) {
                                    findDisplayName();
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            }
                          },
                          child: Text('Save')),
                    ],
                  ),
                ),
              ],
            ));
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
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("images/profile.png"),
                              )),
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        width: 220,
                        child: Column(
                          children: [
                            Container(
                              // color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('$displayName',
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.grey),
                                      onPressed: () {
                                        print('click edit');
                                        editThread();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$email', style: TextStyle(fontSize: 16)),
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
