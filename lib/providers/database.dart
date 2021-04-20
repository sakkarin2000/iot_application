import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_application/main.dart';
import 'package:iot_application/model/event.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference iotCollection =
      FirebaseFirestore.instance.collection('event');

  Future addEvent(String actName, String startTime, String endTime) async {
    return await iotCollection
        .doc(uid)
        .collection('myevent').doc()
        .set({
          'actName': actName,
          'startTime': startTime,
          'endTime': endTime,
        })
        .then((e) => {
              print('Document Added '),
            })
        .catchError((e) => {
              print('Error adding document: ' + e),
            });
  }


  
}
