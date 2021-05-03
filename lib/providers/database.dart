import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_application/main.dart';
import 'package:iot_application/model/event.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('event');

  Future addEvent(String id, String actName, DateTime startTime,
      DateTime endTime, String cat) async {
    return await eventCollection
        .doc(uid)
        .collection('myevent')
        .doc(id)
        .set({
          'id': id,
          'actName': actName,
          'startTime': startTime,
          'endTime': endTime,
          'cat': cat,
        })
        .then((e) => {
              print('Document Added $startTime'),
              print(startTime),
            })
        .catchError((e) => {
              print('Error adding document: ' + e),
            });
  }

  Future updateEvent(String id, String actName, DateTime startTime,
      DateTime endTime, String cat) async {
    return await eventCollection
        .doc(uid)
        .collection('myevent')
        .doc(id)
        .update({
          'actName': actName,
          'startTime': startTime,
          'endTime': endTime,
          'cat': cat,
        })
        .then((e) => {
              print('Document Updated $startTime'),
              print(startTime),
            })
        .catchError((e) => {
              print('Error updating document: ' + e),
            });
  }

  Future removeEvent(String id) async {
    return await eventCollection
        .doc(uid)
        .collection('myevent')
        .doc(id)
        .delete()
        .then((e) => {
              print('Document Removed $id'),
              print(id),
            })
        .catchError((e) => {
              print('Error removing document: ' + e),
            });
  }

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
        id: doc.data()['id'],
        event: doc.data()['actName'],
        start: doc.data()['startTime'],
        stop: doc.data()['endTime'],
        cat: doc.data()['cat'],
      );
    }).toList();
  }

  Future<List<Event>> get myEventNa {
    var eventList = List<Event>.empty(growable: true);
    print(uid);
    print('getEventNAAAAHasbeencalled');
    print(uid);
    return eventCollection
        .doc(uid)
        .collection('myevent')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Event e = new Event(
          id: doc.data()['id'],
          event: doc.data()['actName'],
          start: doc.data()['startTime'].toDate(),
          stop: doc.data()['endTime'].toDate(),
          cat: doc.data()['cat'],
        );

        eventList.add(e);
      });
      return eventList;
    });
  }

  Stream<List<Event>> get myEvent {
    print('getEventHasbeencalled');
    print(uid);
    return eventCollection
        .doc(uid)
        .collection('myevent')
        .snapshots()
        .map(_eventListFromSnapshot);
  }
}
