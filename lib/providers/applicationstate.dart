import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ApplicationState extends ChangeNotifier {
  String credentials;
  ApplicationState() {
    init();
  }
  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        credentials = user.email;
        notifyListeners();
      } else {
        credentials = null;
      }
      notifyListeners();
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    UserInfo userInfo = UserInfo(email: email, password: password);
    try {
      var status = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(userInfo.email);
      if (status.contains('password')) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: userInfo.email, password: userInfo.password);
        } on FirebaseAuthException catch (_) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("Email is already used with others password"),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text("Please create new account"),
                ));
      }
    } on FirebaseAuthException catch (_) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Email is Invalid Format"),
              ));
    }
    notifyListeners();
  }

  Future<void> signup(String email, String displayName, String password,
      BuildContext context) async {
    UserInfo userInfo = UserInfo(email: email, password: password);
    try {
      var status = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userInfo.email, password: userInfo.password);
      await status.user.updateProfile(displayName: displayName);
    } on FirebaseAuthException catch (_) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Email is Invalid Format"),
              ));
    }
    notifyListeners();
  }
}

class UserInfo {
  String email;
  String password;
  UserInfo({this.email, this.password});
}
