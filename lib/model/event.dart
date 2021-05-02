import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String event;
  // String start;
  // String stop;
  final DateTime start;
  final DateTime stop;

  Event( {
    this.id,
    this.event,
    this.start,
    this.stop,
  });
}
