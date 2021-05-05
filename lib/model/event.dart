class Event {
  final String id;
  final String event;
  final DateTime start;
  final DateTime stop;
  final String cat;
  final bool isTimeTable;

  Event( {
    this.id,
    this.event,
    this.start,
    this.stop,
    this.cat,
    this.isTimeTable,
  });
}
