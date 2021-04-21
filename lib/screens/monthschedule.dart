import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_application/model/event.dart';
import 'package:iot_application/providers/applicationstate.dart';
import 'package:iot_application/shared/constant.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot_application/providers/database.dart';

class MonthSchedule extends StatelessWidget {
  String _userId;
  Future<void> getUserId() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        _userId = event.uid;
        print('uid of this user: $_userId');
        print(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserId();
    return StreamProvider<List<Event>>.value(
      initialData: null,
      value: DatabaseService(uid: _userId).myEvent,
      child: MaterialApp(
        title: 'Flutter Calendar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.maliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  TextEditingController _startController;
  TextEditingController _stopController;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final time = new DateFormat('HH:mm');
  bool _eventAlert = false;
  String _eventAlertText = "";
  String _userId;
  List<Event> myEventList;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _startController = TextEditingController();
    _stopController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    getUserId();
    getEventList();
  }

  Future<void> getEvent() async {
    print('event list\n');
    // print(_events);
  }

  Future<void> getUserId() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          _userId = event.uid;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _eventController.dispose();
    _startController.dispose();
    _stopController.dispose();
    super.dispose();
  }

  Future<void> getEventList() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          this._userId = event.uid;
        });
      });
    });
    List<Event> eventlist = await DatabaseService(uid: _userId).myEventNa;
    setState(() {
      myEventList = eventlist;
    });
    print('_userId $_userId');
    print('Here is ');
    myEventList.forEach((myEvent) {
      print(
          'EventName : ${myEvent.event} StartTime : ${myEvent.start} EndTime : ${myEvent.stop}');
      DateTime temp = new DateTime(
          myEvent.start.year,
          myEvent.start.month,
          myEvent.start.day,
          12,
          0,
          myEvent.start.second,
          myEvent.start.millisecond,
          myEvent.start.microsecond);

      if (_events[temp] != null) {
        _events[temp].add(Event(
            event: myEvent.event, start: myEvent.start, stop: myEvent.stop));
      } else {
        _events[temp] = [
          Event(event: myEvent.event, start: myEvent.start, stop: myEvent.stop),
        ];
      }
      _events[temp].sort((a, b) {
        var sa = a.start.hour * 60 + a.start.minute;
        var sb = b.start.hour * 60 + b.start.minute;
        return sa - sb;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    ); //for bottom part
    String dateSuffix(int day) {
      if (day != null) {
        String suffix;
        if (day % 10 == 1) {
          suffix = 'st';
        } else if (day % 10 == 2) {
          suffix = 'nd';
        } else if (day % 10 == 3) {
          suffix = 'rd';
        } else {
          suffix = 'th';
        }
        return suffix;
      }
      return '';
    }

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String checkWhatDay(DateTime date) {
      if (date != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        final tomorrow = DateTime(now.year, now.month, now.day + 1);

        final dateToCheck = date;
        final aDate =
            DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
        if (aDate == today) {
          return 'Today';
        } else if (aDate == yesterday) {
          return 'Yesterday';
        } else if (aDate == tomorrow) {
          return 'Tomorrow';
        } else {
          return '${date.day}${dateSuffix(date.day)} ${months[date.month]} ${date.year}';
        }
      }
      return '';
    }

    return Scaffold(
      drawer: Hamburgerja(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF30415E)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: iotlogo,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Planning',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Color(0xFF30415E),
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      )),
                  Text('Your Event',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Color(0xFF30415E),
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      )),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              color: Color(0xFFEFF4FF),
              margin: const EdgeInsets.all(25.0),
              child: TableCalendar(
                events: _events,
                weekendDays: [],
                initialCalendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: '',
                },
                calendarStyle: CalendarStyle(
                    unavailableStyle: TextStyle(fontWeight: FontWeight.w700),
                    weekdayStyle: TextStyle(
                        color: Color(0xFF153970), fontWeight: FontWeight.w700),
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                      color: Color(0xFF153970),
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.0)),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                onDaySelected: (date, events, event2) {
                  // print(date);
                  print(time.format(_start));
                  print('Controller.selectedDay : ${_controller.selectedDay}');
                  print(
                      'Controller.selectedDay : ${_controller.selectedDay.day}${dateSuffix(_controller.selectedDay.day)} ${months[_controller.selectedDay.month]} ${_controller.selectedDay.year}');
                  print('_selectedEvents = events which is : ${events}');
                  setState(() {
                    _selectedEvents = events;
                  });

                  // print(_events.toString());
                  // print(_events.length);

                  ////generate event testing
                  // for(int i=0;i<50;i++) {
                  //   events.add(Event(
                  //       event: "${i}",
                  //       start: DateTime.now().add(Duration(minutes: i)),
                  //       stop: DateTime.now().add(Duration(minutes: i+1))));
                  // }

                  ////events checking
                  // String a = "";
                  // for (Event e in _events[date]) {
                  //   print('Date in for loop${e.start}');
                  //   a +=
                  //       ", ${e.event} ${time.format(e.start)}-${time.format(e.stop)}";
                  // }
                  // if (a.isNotEmpty) {
                  //   print(a);
                  // }
                },
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          // borderRadius: BorderRadius.circular(10.0),
                          shape: BoxShape.circle),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          // borderRadius: BorderRadius.circular(10.0),
                          shape: BoxShape.circle),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
              ),
            ),
          ],
        ),
        SlidingUpPanel(
          isDraggable: false,
          minHeight: (274.0 +
              (_selectedEvents.length > 4
                  ? (_selectedEvents.length - 4) * 56.0
                  : 0.0)),
          maxHeight: (274.0 +
              (_selectedEvents.length > 4
                  ? (_selectedEvents.length - 4) * 56.0
                  : 0.0)),
          panel: Center(
            child: Text("This is the sliding Widget"),
          ),
          collapsed: Container(
              decoration:
                  BoxDecoration(color: Color(0xFF153970), borderRadius: radius),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7.5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 60, right: 60),
                          child: Text(
                              "${checkWhatDay(_controller.selectedDay)}'s Events",
                              style: GoogleFonts.mali(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                  ..._selectedEvents.map((value) => ListTile(
                        title: Text(
                            "${value.event} @${time.format(value.start)}-${time.format(value.stop)}",
                            style: GoogleFonts.mali(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            )),
                      )),
                ],
              )),
          borderRadius: radius,
        )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF17A489),
        child: Icon(Icons.add),
        onPressed: () {
          _eventController.clear();
          setState(() {
            _eventAlert = false;
            _eventAlertText = "";
            _start = _controller.selectedDay;
            _stop = _start.add(Duration(hours: 1));
          });
          _showAddDialog();
        },
      ),
    );
  }

  _showAddDialog() async {
    print(_selectedEvents);
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    TextField(
                      controller: _eventController,
                      decoration: InputDecoration(
                          labelText: "Event", hintText: "Enter event name"),
                      onChanged: (text) {
                        if (text.isEmpty) {
                          print("Please fill event name");
                          setState(() {
                            _eventAlert = true;
                            _eventAlertText = "Please fill event name";
                          });
                        } else if (text.trim().isEmpty) {
                          print("Event name cannot be blank");
                          setState(() {
                            _eventAlert = true;
                            _eventAlertText = "Event name cannot be blank";
                          });
                        } else {
                          setState(() {
                            _eventAlert = false;
                            _eventAlertText = "";
                          });
                        }
                      },
                    ),
                    Text("Start Time"),
                    SizedBox(
                        height: 50,
                        width: 700,
                        child: CupertinoDatePicker(
                            initialDateTime: _start,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            onDateTimeChanged: (dateTime) {
                              print(dateTime);
                              setState(() {
                                _eventAlert = false;
                                _eventAlertText = "";
                                _start = dateTime;
                              });
                            })),
                    Text("Stop Time"),
                    SizedBox(
                        height: 50,
                        width: 700,
                        child: CupertinoDatePicker(
                            initialDateTime: _stop,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            onDateTimeChanged: (dateTime) {
                              print(dateTime);
                              setState(() {
                                _eventAlert = false;
                                _eventAlertText = "";
                                _stop = dateTime;
                              });
                            })),
                    Opacity(
                      opacity: _eventAlert ? 1 : 0,
                      child: Text(_eventAlertText,
                          style: GoogleFonts.mali(
                            textStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          )),
                    )
                  ])),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    if (_selectedEvents != null) {
                      _selectedEvents.add('temporary fix');
                      _selectedEvents.removeLast();
                    } else {
                      _selectedEvents = ['temporary fix'];
                      _selectedEvents.removeLast();
                    }
                    // _start = new DateTime(_start.year, _start.month, _start.day, 12, 0, _start.second, _start.millisecond, _start.microsecond);
                    // _stop = new DateTime(_stop.year, _stop.month, _stop.day, 12, 0, _stop.second, _stop.millisecond, _stop.microsecond);
                    Navigator.pop(context, false);
                    // Navigator.pop(null);
                  },
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) {
                      print("Please fill event name");
                      setState(() {
                        _eventAlert = true;
                        _eventAlertText = "Please fill event name";
                      });
                      return;
                    } else if (_eventController.text.trim().isEmpty) {
                      print("Event name cannot be blank");
                      setState(() {
                        _eventAlert = true;
                        _eventAlertText = "Event name cannot be blank";
                      });
                      return;
                    }

                    var s2 = _start.hour * 60 + _start.minute;
                    var e2 = _stop.hour * 60 + _stop.minute;

                    if (e2 <= s2) {
                      print("Stop time must be after Start time");
                      setState(() {
                        _eventAlert = true;
                        _eventAlertText = "Stop time must be after Start time";
                      });
                      return;
                    }

                    if (_selectedEvents != null) {
                      for (Event e in _selectedEvents) {
                        var s1 = e.start.hour * 60 + e.start.minute;
                        var e1 = e.stop.hour * 60 + e.stop.minute;

                        if ((s2 <= s1 && s1 < e2) ||
                            (s2 < e1 && e1 <= e2) ||
                            (s1 <= s2 && e2 <= e1)) {
                          print("case1");
                          print(s2 <= s1 && s1 <= e2);
                          print("case2");
                          print(s2 < e1 && e1 <= e2);
                          print("case3");
                          print(s1 <= s2 && e2 <= e1);

                          setState(() {
                            _eventAlert = true;
                            _eventAlertText =
                                "Conflict with ${e.event} @${time.format(e.start)}-${time.format(e.stop)}";
                          });
                          return;
                        }
                        print(
                            "${e.event} ${time.format(e.start)}-${time.format(e.stop)}");
                      }
                    }

                    if (_selectedEvents != null) {
                      _selectedEvents.add(Event(
                          event: _eventController.text
                              .trim()
                              .replaceAll(RegExp(" +"), " "),
                          start: _start,
                          stop: _stop));

                      _selectedEvents.sort((a, b) {
                        var sa = a.start.hour * 60 + a.start.minute;
                        var sb = b.start.hour * 60 + b.start.minute;
                        return sa - sb;
                      });

                      print('[DB] Add new event to the day');
                    } else {
                      _selectedEvents = [
                        Event(
                            event: _eventController.text
                                .trim()
                                .replaceAll(RegExp(" +"), " "),
                            start: _start,
                            stop: _stop)
                      ];

                      print('[DB] Add first event to the day');
                    }
                    DatabaseService(uid: _userId).addEvent(
                      _eventController.text
                          .trim()
                          .replaceAll(RegExp(" +"), " "),
                      _start,
                      _stop,
                    );
                    _events[_controller.selectedDay] = _selectedEvents;
                    // _start = new DateTime(_start.year, _start.month, _start.day, 12, 0, _start.second, _start.millisecond, _start.microsecond);
                    // _stop = new DateTime(_stop.pyear, _stop.month, _stop.day, 12, 0, _stop.second, _stop.millisecond, _stop.microsecond);
                    Navigator.pop(context, true);
                    // Navigator.pop(context);
                  },
                )
              ],
            );
          });
        }).then((event) {
      if (event == null) return;
      if (event) {
      } else {}
    });
    setState(() {
      _events[_controller.selectedDay] = _selectedEvents;
    });
  }
}
