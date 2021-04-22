import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_application/main.dart';
import 'package:iot_application/model/event.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('event');

  Future addEvent(String actName, DateTime startTime, DateTime endTime) async {
    return await eventCollection
        .doc(uid)
        .collection('myevent')
        .doc()
        .set({
          'actName': actName,
          'startTime': startTime,
          'endTime': endTime,
        })
        .then((e) => {
              print('Document Added $startTime'),
              print(startTime),
            })
        .catchError((e) => {
              print('Error adding document: ' + e),
            });
  }

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
          event: doc.data()['actName'],
          start: doc.data()['startTime'],
          stop: doc.data()['endTime']);
    }).toList();
  }

  Future<List<Event>> get myEventNa {
    var eventList = List<Event>.empty(growable: true);
    return eventCollection
        .doc(uid)
        .collection('myevent')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Event e = new Event(
          event: doc.data()['actName'],
          start:
              doc.data()['startTime'].toDate(),
          stop: doc.data()['endTime'].toDate(),
        );

        eventList.add(e);
      });
      return eventList;
    });
  }

  Stream<List<Event>> get myEvent {
    return eventCollection
        .doc(uid)
        .collection('myevent')
        .snapshots()
        .map(_eventListFromSnapshot);
  }
}
