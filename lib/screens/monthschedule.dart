import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_application/model/event.dart';
import 'package:iot_application/providers/applicationstate.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot_application/providers/database.dart';

class MonthSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.maliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
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
  bool _timeConflict = false;
  String _timeConflictText = "";
  String _userId;


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

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    ); //for bottom part

    var logo = [
      Text('I',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(0xFFBED4DF),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      Text('o',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(0xFFCCADA5),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      Text('T',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(0xFFFFB9A3),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
    ];
    return Scaffold(
      drawer: Hamburgerja(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF30415E)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: logo,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(children: <Widget>[
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
                  setState(() {
                    _selectedEvents = events;

                    //
                    // String a="";
                    // for(Event e in events){
                    //   print("${e.event} ${time.format(e.start)}-${time.format(e.stop)} : ${e.start.isBefore(e.stop)}");
                    //   a+=", ${e.event} ${time.format(e.start)}-${time.format(e.stop)}";
                    // }
                    // if(a.isNotEmpty){
                    //   print(a);
                    // }
                    //

                  });
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
          minHeight: 210,
          maxHeight: 210,
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
                          child: Text("Today's Events",
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
          setState(() {
            _timeConflict = false;
            _timeConflictText = "";
            _start = _controller.selectedDay;
            _stop = _start.add(Duration(hours: 1));
          });
          _showAddDialog();
        },
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    content: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextField(
                                  controller: _eventController,
                                  decoration: InputDecoration(
                                      labelText: "Event",
                                      hintText: "Enter event name")),
                              Text("Start Time"),
                              SizedBox(
                                  height: 50,
                                  width: 700,
                                  child: CupertinoDatePicker(
                                      initialDateTime: _start,
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged: (dateTime){
                                        print(dateTime);
                                        setState(() {
                                          _timeConflict=false;
                                          _start=dateTime;
                                        });
                                      })
                              ),
                              Text("Stop Time"),
                              SizedBox(
                                  height: 50,
                                  width: 700,
                                  child: CupertinoDatePicker(
                                      initialDateTime: _stop,
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged: (dateTime){
                                        print(dateTime);
                                        setState(() {
                                          _timeConflict=false;
                                          _stop=dateTime;
                                        });
                                      })
                              ),
                              Opacity (
                                opacity: _timeConflict? 1:0,
                                child: Text(_timeConflictText,
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
                          if (_events[_controller.selectedDay] != null) {
                            _events[_controller.selectedDay].add('temporary fix');
                            _events[_controller.selectedDay].removeLast();
                          } else {
                            _events[_controller.selectedDay] = ['temporary fix'];
                            _events[_controller.selectedDay].removeLast();
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
                          setState((){
                            _start=_start;
                            _stop=_stop;
                          });

                          if (_eventController.text.isEmpty){
                            print("Please fill activity name");
                            setState(() {
                              _timeConflict=true;
                              _timeConflictText="Please fill activity name";
                            });
                            return;
                          }

                          var s2=_start.hour*60+_start.minute;
                          var e2=_stop.hour*60+_stop.minute;

                          if(e2<=s2){
                            print("Stop time must be after Start time");
                            setState(() {
                              _timeConflict=true;
                              _timeConflictText="Stop time must be after Start time";
                            });
                            return;
                          }

                          if (_events[_controller.selectedDay] != null) {
                            for (Event e in _events[_controller.selectedDay]) {

                              var s1=e.start.hour*60+e.start.minute;
                              var e1=e.stop.hour*60+e.stop.minute;

                              if ((s2<=s1 && s1<e2)||
                                  (s2<e1 && e1<=e2)||
                                  (s1<=s2 && e2<=e1)
                              ) {
                                print("case1");
                                print(s2<=s1 && s1<=e2);
                                print("case2");
                                print(s2<e1 && e1<=e2);
                                print("case3");
                                print(s1<=s2 && e2<=e1);

                                setState(() {
                                  _timeConflict=true;
                                  _timeConflictText="Conflict with @${e.event} ${time.format(e.start)}-${time.format(e.stop)}";
                                });
                                return;
                              }
                              print("${e.event} ${time.format(e.start)}-${time.format(e.stop)}");
                            }
                          }

                          if (_events[_controller.selectedDay] != null) {
                            _events[_controller.selectedDay].add(Event(
                                _eventController.text,_start,_stop));
                          } else {
                            _events[_controller.selectedDay] = [
                              Event(_eventController.text, _start, _stop)
                            ];
                          }
                          print('Add to db2');
                          DatabaseService(uid: _userId).addEvent(
                                _eventController.text,
                                _start.toString(),
                                _stop.toString()
                          );
                          // _start = new DateTime(_start.year, _start.month, _start.day, 12, 0, _start.second, _start.millisecond, _start.microsecond);
                          // _stop = new DateTime(_stop.year, _stop.month, _stop.day, 12, 0, _stop.second, _stop.millisecond, _stop.microsecond);
                          _eventController.clear();
                          _startController.clear();
                          _stopController.clear();
                          Navigator.pop(context, true);
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  );
              }
          );
        }
    ).then((event) {
      if (event == null) return;
      if (event) {
      } else {}
    });
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }
}