import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:uuid/uuid.dart';

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
      child:
    // GestureDetector(
    //     onTap: () {
    //       FocusScopeNode currentFocus = FocusScope.of(context);
    //
    //       if (!currentFocus.hasPrimaryFocus) {
    //         currentFocus.unfocus();
    //       }
    //     },
    //     child:
    MaterialApp(
          title: 'Flutter Calendar',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.maliTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: HomePage(),
        ),
      // ),
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
  TextEditingController _repeatController;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final time = new DateFormat('HH:mm');
  final datetime = new DateFormat('dd-MM-yyyy HH:mm');
  bool _eventAlert = false;
  String _eventAlertText = "";
  String _userId;
  List<Event> myEventList;
  var uuid = Uuid();
  String _catValue;
  int catColor;
  final Map<String, int> catMap = {
    "Family": 0xffFECD4C,
    "Friend": 0xff58DCE4,
    "School": 0xffE17262,
    "Personal": 0xff9776F8,
    "Special": 0xffFFB9A3,
    "Other": 0xffE5A4ED,
  };
  List<dynamic> _addList=[];
  bool _addMore=false;
  final Map<String, int> weekColor = {
    "Sunday": 0xffff0000,
    "Monday": 0xffffff00,
    "Tuesday": 0xffffc0cb,
    "Wednesday": 0xff008000,
    "Thursday": 0xffffa500,
    "Friday": 0xff00bfff,
    "Saturday": 0xff800080,
  };
  int _repeat=0;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _repeatController=TextEditingController();
    _events = {};
    _selectedEvents = [];
    getUserId();
    getEventList();
    _addMore=false;
    _addList=[];
    _repeat=0;
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
    // _controller.dispose();
    // _eventController.dispose();
    // _repeatController.dispose();
    super.dispose();
  }

  Future<void> getEventList() async {
    print('getEventList has been called');
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          this._userId = event.uid;
        });
        List<Event> eventlist = await DatabaseService(uid: event.uid).myEventNa;
        setState(() {
          myEventList = eventlist;
        });
        print('Here iss ');
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
              myEvent.start.microsecond).toUtc();

          if (_events[temp] != null) {
            _events[temp].add(Event(
                id: myEvent.id,
                event: myEvent.event,
                start: myEvent.start,
                stop: myEvent.stop,
                cat: myEvent.cat));
          } else {
            _events[temp] = [
              Event(
                  id: myEvent.id,
                  event: myEvent.event,
                  start: myEvent.start,
                  stop: myEvent.stop,
                  cat: myEvent.cat),
            ];
          }
          _events[temp].sort((a, b) {
            var sa = a.start.hour * 60 + a.start.minute;
            var sb = b.start.hour * 60 + b.start.minute;
            return sa - sb;
          });
        });
      });
    });
    print('_userId $_userId');
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
                  Text('Your Events',
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
                    unavailableStyle: TextStyle(
                        color: Color(0xFF153970), fontWeight: FontWeight.w700),
                    weekdayStyle: TextStyle(
                        color: Color(0xFF153970), fontWeight: FontWeight.w700),
                    selectedStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700
                    ),
                    eventDayStyle: TextStyle(
                        color: Color(0xFF153970), fontWeight: FontWeight.w700),
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                        color: Colors.white),
                ),
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

                  //generate event testing
                  // String nme="";
                  // for(int i=0;i<10;i++){
                  //   nme+="Z";
                  // }
                  // for(int i=0;i<100;i++) {
                  //   events.add(Event(
                  //       id: "1",
                  //       event: "${i} ${nme}",
                  //       start: DateTime.now().add(Duration(minutes: i)),
                  //       stop: DateTime.now().add(Duration(minutes: i+1)),
                  //       cat: "Family"
                  //   ));
                  // }

                  ////events checking
                  // String a = "";
                  // for (Event e in _selectedEvents) {
                  //   print('Date in for loop${e.start}');
                  //   // a +=
                  //   //     ", ${e.event} ${time.format(e.start)}-${time.format(e.stop)}";
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
                      )
                  ),
                  markersBuilder: (context, date, events, holidays) {
                    final children = <Widget>[
                    ];
                    if (events.isNotEmpty) {
                      children.add(
                        Positioned(
                          bottom: 1.0-(events.length>99? 5.0:0),
                          right: -3.0-(events.length>99? 5.0:0),
                          child:
                          Container(
                              width: 16.0+(events.length>99? 5.0:0),
                              height: 16.0+(events.length>99? 5.0:0),
                                  // +(events.length>99? 6.0*(('${events.length}').length-2):0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _controller.isSelected(date)? Colors.lightBlue : _controller.isToday(date)? Colors.orangeAccent: Colors.green,
                                  shape: BoxShape.circle),
                              child:Text('${events.length>99? '99+':events.length}',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              )
                          ),
                        ),
                      );
                    }
                    return children;
                  },
                ),
                calendarController: _controller,
              ),
            ),
          ],
        ),
        SlidingUpPanel(
          isDraggable: false,
          minHeight: 274.0
          //(274.0)
              // +(_selectedEvents.length > 4
              //     ? (_selectedEvents.length - 4) * 56.0
              //     : 0.0))
          ,
          maxHeight: 274.0
          //(274.0)
              // +(_selectedEvents.length > 4
              //     ? (_selectedEvents.length - 4) * 56.0
              //     : 0.0))
          ,
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
                  Container(
                    width: 700.0,
                    height: 224.0,
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.rectangle,
                    //   color: const Color(0xFFFFFF),
                    //   borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
                    //   border: Border.all(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    // ),
                    child:  ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20.0),
                          children: [
                            ..._selectedEvents.map((value) => ListTile(
                              title:
                              Container(
                                width: 700.0,
                                height: 30.0,
                                child: ListView(
                                  shrinkWrap: true,
                                  // padding: const EdgeInsets.all(20.0),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8, top: 3),
                                          child: Icon(Icons.circle, color: Color(catMap[value.cat]), size: 16),
                                        ),
                                        Text(
                                            "${value.event} @${time.format(value.start)}-${time.format(value.stop)}",
                                            style: GoogleFonts.mali(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            )
                                        ),
                                        IconButton(
                                          icon:
                                          Icon(Icons.edit, color: Colors.white, size: 19),
                                          onPressed: () {
                                            print('click edit');
                                            setState(() {
                                              _eventController.text = value.event;
                                              _eventAlert = false;
                                              _eventAlertText = "";
                                              _start = value.start;
                                              _stop = value.stop;
                                              _catValue = value.cat;
                                            });
                                            _showAddDialog(1,value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ]
                      ),
                    ),
                  
                ],

              )),
          borderRadius: radius,
        )
      ]),

      floatingActionButton:

      Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              // backgroundColor: Color(0xFF17A489),
              color:Colors.white,
              // child: Icon(Icons.add),
              icon: Icon(Icons.add),
                onPressed: () {
                  _eventController.clear();
                  setState(() {
                    _eventAlert = false;
                    _eventAlertText = "";
                    _start = _controller.selectedDay.toLocal().subtract(Duration(hours:7));
                    _stop = _controller.selectedDay.toLocal().subtract(Duration(hours:6));
                    _catValue = 'Family';
                    _addMore=false;
                    _addList=[];
                  });
                  _showAddDialog(0,null);
                },
            ),
            SizedBox(
              height: 10,
            ),
              IconButton(
              // backgroundColor: Color(0xFF17A489),
              color:Colors.white,
              // child: Icon(Icons.library_add_outlined),
              icon: Icon(Icons.library_add_outlined),
              onPressed: () {
                final Map<String, int> week = {
                  "Sunday": 0,
                  "Monday": 1,
                  "Tuesday": 2,
                  "Wednesday": 3,
                  "Thursday": 4,
                  "Friday": 5,
                  "Saturday": 6,
                };
                String day=DateFormat('EEEE').format(_controller.selectedDay);
                int min=week[day];
                int max=6-week[day];

                _eventController.clear();
                setState(() {
                  _eventAlert = false;
                  _eventAlertText = "";
                  _start = _controller.selectedDay.toLocal().subtract(Duration(hours:7));
                  _stop = _controller.selectedDay.toLocal().subtract(Duration(hours:6));
                  _catValue = 'Family';
                  _addMore=false;
                  _addList=[];
                });

                DateTime minDate=_controller.selectedDay.subtract(Duration(days:min));
                DateTime maxDate=_controller.selectedDay.add(Duration(days:max));
                DateTime minTime=new DateTime(
                    minDate.year,
                    minDate.month,
                    minDate.day,
                    0,
                    0
                );
                DateTime maxTime=new DateTime(
                    maxDate.year,
                    maxDate.month,
                    maxDate.day,
                    23,
                    59
                );

                _showRoutineDialog(minTime,maxTime);
              },
            ),

          ]
      )
    );
  }

  _showAddDialog(int type, Event argEvent) async {
    print(_selectedEvents);
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
            // title: Center(child:Text(type==0? "Add Event":"Edit Event")),
            content: Container(
              width: 700.0,
              height: type==1? 350.0:_addMore? 500.0:350.0,
              decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Visibility (
                        visible: type==1 ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon:
                              Icon(Icons.delete, color: Colors.black),
                              onPressed: () {
                                String id=argEvent.id;
                                _selectedEvents.remove(argEvent);
                                DatabaseService(uid: _userId).removeEvent(id);
                                Navigator.pop(context, false);
                              },
                            ),
                          ],
                        ),
                    ),
                    Center(child:
                      Text(type==0? "Add Event":"Edit Event",
                          style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ))
                    ),
                    Visibility (
                        visible: type==0 ? true : false,
                        child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _addMore = !_addMore;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(103, 30),
                                  side: BorderSide(color: Colors.blueGrey[300], width: 1 ),
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(15))),
                              child: Text(
                                _addMore? 'Back' : 'Add More Events',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
                      child: TextField(
                        controller: _eventController,
                        maxLength: 50,
                        decoration: InputDecoration(
                            labelText: "Event", hintText: "Enter event name",
                            counterText: '',
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                        ),
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
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Start Time"),
                                SizedBox(
                                    height: 50,
                                    width: 160,
                                    child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                            dateTimePickerTextStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        child: CupertinoDatePicker(
                                          initialDateTime: _start,
                                          mode: CupertinoDatePickerMode.dateAndTime,
                                          use24hFormat: true,
                                          onDateTimeChanged: (dateTime) {
                                            print(dateTime);
                                            setState(() {
                                              _eventAlert = false;
                                              _eventAlertText = "";
                                              _start = dateTime;
                                            });
                                          }
                                        )
                                    )
                                ),
                              ]
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Stop Time"),
                                SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                            dateTimePickerTextStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
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
                                            }
                                        )
                                    )
                                ),
                              ]
                          ),
                        ]
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: DropdownButton<String>(
                              value: _catValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style: const TextStyle(color: Colors.grey),
                              underline: Container(
                                height: 2,
                                color: Colors.black26,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  _catValue = newValue;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              items: [
                                'Family',
                                'Friend',
                                'School',
                                'Personal',
                                'Special',
                                'Other'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child:Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.circle, color: Color(catMap[value]), size: 20),
                                      ),
                                      Text(value,
                                          style: GoogleFonts.mali(
                                            textStyle: TextStyle(
                                              // color: Color(catMap[value]),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          )),
                                    ]),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    Visibility (
                      visible: (_addMore && type==0) ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          width: 700.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFFFFF),
                            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: ListView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                children: [
                                  ..._addList.map((value) => ListTile(
                                    title:
                                    Container(
                                      width: 700.0,
                                      height: 28.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: const Color(0xFFFFFF),
                                        borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                                        border: Border.all(
                                          color: Color(weekColor[DateFormat('EEEE').format(value.start)]),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: ListView(
                                        shrinkWrap: true,
                                        // padding: const EdgeInsets.all(20.0),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 6.0, left: 6, top: 2),
                                                child: Icon(Icons.circle, color: Color(catMap[value.cat]),size: 18,),
                                              ),
                                              Text(
                                                  "${value.event} @${datetime.format(value.start)}-${time.format(value.stop)}",
                                                  style: GoogleFonts.mali(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                              ),
                                              SizedBox(
                                                height: 18.0,
                                                width: 18.0,
                                                child: IconButton(
                                                  icon:
                                                  Icon(Icons.delete, color: Colors.black, size: 18.0),
                                                  padding: const EdgeInsets.only(bottom: 50.0),
                                                  onPressed: () {
                                                    setState(() {
                                                      _addList.remove(value);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ]
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility (
                      visible: (_addMore && type==0) ? true : false,
                      child: Center(
                          child: MaterialButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              DateTime index = new DateTime(
                                _start.year,
                                _start.month,
                                _start.day,
                                12,
                                0,
                                _start.second,
                                _start.millisecond,
                                _start.microsecond,
                              ).toUtc();
                              DateTime temp = new DateTime(
                                _start.year,
                                _start.month,
                                _start.day,
                                _stop.hour,
                                _stop.minute,
                                _start.second,
                                _start.millisecond,
                                _start.microsecond,
                              );
                              setState(() {
                                _stop=temp;
                              });

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

                              var md2 = _start.month * 31 + _start.day;

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

                              if (_addList != null) {
                                for (Event e in _addList) {

                                  var md1 = e.start.month * 31 + e.start.day;

                                  if(md1!=md2){
                                    continue;
                                  }

                                  var s1 = e.start.hour * 60 + e.start.minute;
                                  var e1 = e.stop.hour * 60 + e.stop.minute;

                                  if ((s2 <= s1 && s1 < e2) ||
                                      (s2 < e1 && e1 <= e2) ||
                                      (s1 <= s2 && e2 <= e1)) {

                                    setState(() {
                                      _eventAlert = true;
                                      _eventAlertText =
                                      "Conflict in list: ${e.event} @${datetime.format(e.start)}-${time.format(e.stop)}";
                                    });
                                    return;
                                  }
                                }
                              }
                              if (_events[index] != null) {
                                for (Event e in _events[index]) {

                                  var s1 = e.start.hour * 60 + e.start.minute;
                                  var e1 = e.stop.hour * 60 + e.stop.minute;

                                  if ((s2 <= s1 && s1 < e2) ||
                                      (s2 < e1 && e1 <= e2) ||
                                      (s1 <= s2 && e2 <= e1)) {

                                    setState(() {
                                      _eventAlert = true;
                                      _eventAlertText =
                                      "Conflict with ${e.event} @${datetime.format(e.start)}-${time.format(e.stop)}";
                                    });
                                    return;
                                  }
                                }
                              }

                              String id = uuid.v1();
                              if (_addList != null) {
                                setState(() {
                                  _addList.add(Event(
                                    id: id,
                                    event: _eventController.text
                                        .trim()
                                        .replaceAll(RegExp(" +"), " "),
                                    start: _start,
                                    stop: _stop,
                                    cat: _catValue,
                                  ));
                                });


                                _addList.sort((a, b) {
                                  var mda = a.start.month * 31 + a.start.day;
                                  var mdb = b.start.month * 31 + b.start.day;

                                  var sa = a.start.hour * 60 + a.start.minute;
                                  var sb = b.start.hour * 60 + b.start.minute;

                                  if(mda==mdb){
                                    return sa - sb;
                                  }else{
                                    return mda-mdb;
                                  }
                                });
                              } else {
                                setState(() {
                                  _addList = [
                                    Event(
                                      id: id,
                                      event: _eventController.text
                                          .trim()
                                          .replaceAll(RegExp(" +"), " "),
                                      start: _start,
                                      stop: _stop,
                                      cat: _catValue,
                                    )
                                  ];
                                });
                              }
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Icon(
                              Icons.add,
                              size: 22,
                            ),
                            padding: EdgeInsets.all(12),
                            shape: CircleBorder(),
                          )
                      ),
                    ),
                    Opacity(
                        opacity: _eventAlert ? 1 : 0,
                        child: Center(
                          child: Text(_eventAlertText,
                              style: GoogleFonts.mali(
                                textStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              )),
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(103, 30),
                                primary: Colors.grey,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5.0))),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if(_addMore) {
                                int listIndex=0;
                                for(Event i in _addList){
                                  listIndex++;
                                  DateTime index = new DateTime(
                                    i.start.year,
                                    i.start.month,
                                    i.start.day,
                                    12,
                                    0,
                                    i.start.second,
                                    i.start.millisecond,
                                    i.start.microsecond,
                                  ).toUtc();
                                  DateTime Lstop = new DateTime(
                                    i.start.year,
                                    i.start.month,
                                    i.start.day,
                                    i.stop.hour,
                                    i.stop.minute,
                                    i.start.second,
                                    i.start.millisecond,
                                    i.start.microsecond,
                                  );

                                  var s2 = i.start.hour * 60 + i.start.minute;
                                  var e2 = Lstop.hour * 60 + Lstop.minute;

                                  if (_events[index] != null) {
                                    for (Event e in _events[index]) {
                                      if(type==1){
                                        if(e.start==argEvent.start){
                                          continue;
                                        }
                                      }
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
                                          "Conflict with ${e.event} @${datetime.format(e.start)}-${time.format(e.stop)}";
                                        });
                                        return;
                                      }
                                      print(
                                          "${e.event} ${datetime.format(e.start)}-${time.format(e.stop)}");
                                    }
                                  }

                                  if(type==0) {
                                    String id = uuid.v1();
                                    if (_events[index] != null) {
                                      _events[index].add(Event(
                                        id: id,
                                        event: i.event
                                            .trim()
                                            .replaceAll(RegExp(" +"), " "),
                                        start: i.start,
                                        stop: Lstop,
                                        cat: i.cat,
                                      ));

                                      _events[index].sort((a, b) {
                                        var sa = a.start.hour * 60 + a.start.minute;
                                        var sb = b.start.hour * 60 + b.start.minute;
                                        return sa - sb;
                                      });

                                      print('[DB] Add new event to the day');
                                    } else {
                                      _events[index] = [
                                        Event(
                                          id: id,
                                          event: i.event
                                              .trim()
                                              .replaceAll(RegExp(" +"), " "),
                                          start: i.start,
                                          stop: Lstop,
                                          cat: i.cat,
                                        )
                                      ];

                                      print('[DB] Add first event to the day');
                                    }

                                    DatabaseService(uid: _userId).addEvent(
                                      id,
                                      i.event
                                          .trim()
                                          .replaceAll(RegExp(" +"), " "),
                                      i.start,
                                      Lstop,
                                      i.cat,
                                    );
                                  }
                                  else if(type==1) {
                                    String id = argEvent.id;
                                    _events[index].remove(argEvent);

                                    if (_events[index] != null) {
                                      _events[index].add(Event(
                                        id: id,
                                        event: i.event
                                            .trim()
                                            .replaceAll(RegExp(" +"), " "),
                                        start: i.start,
                                        stop: Lstop,
                                        cat: i.cat,
                                      ));

                                      _events[index].sort((a, b) {
                                        var sa = a.start.hour * 60 + a.start.minute;
                                        var sb = b.start.hour * 60 + b.start.minute;
                                        return sa - sb;
                                      });
                                    } else {
                                      _events[index] = [
                                        Event(
                                          id: id,
                                          event: i.event
                                              .trim()
                                              .replaceAll(RegExp(" +"), " "),
                                          start: i.start,
                                          stop: Lstop,
                                          cat: i.cat,
                                        )
                                      ];
                                    }

                                    print('[DB] Update event');
                                    DatabaseService(uid: _userId).updateEvent(
                                      id,
                                      i.event
                                          .trim()
                                          .replaceAll(RegExp(" +"), " "),
                                      i.start,
                                      Lstop,
                                      i.cat,
                                    );
                                  }

                                  if("${index.toString()}Z"=="${_controller.selectedDay}"){
                                    setState(() {
                                      _selectedEvents=_events[index];
                                    });
                                  }

                                }
                              }else{
                                DateTime index = new DateTime(
                                  _start.year,
                                  _start.month,
                                  _start.day,
                                  12,
                                  0,
                                  _start.second,
                                  _start.millisecond,
                                  _start.microsecond,
                                ).toUtc();
                                DateTime temp = new DateTime(
                                  _start.year,
                                  _start.month,
                                  _start.day,
                                  _stop.hour,
                                  _stop.minute,
                                  _start.second,
                                  _start.millisecond,
                                  _start.microsecond,
                                );
                                setState(() {
                                  _stop=temp;
                                });

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

                                if (_events[index] != null) {
                                  for (Event e in _events[index]) {
                                    if(type==1){
                                      if(e.start==argEvent.start){
                                        continue;
                                      }
                                    }
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

                                if(type==0) {
                                  String id = uuid.v1();
                                  if (_events[index] != null) {
                                    _events[index].add(Event(
                                      id: id,
                                      event: _eventController.text
                                          .trim()
                                          .replaceAll(RegExp(" +"), " "),
                                      start: _start,
                                      stop: _stop,
                                      cat: _catValue,
                                    ));

                                    _events[index].sort((a, b) {
                                      var sa = a.start.hour * 60 + a.start.minute;
                                      var sb = b.start.hour * 60 + b.start.minute;
                                      return sa - sb;
                                    });

                                    print('[DB] Add new event to the day');
                                  } else {
                                    _events[index] = [
                                      Event(
                                        id: id,
                                        event: _eventController.text
                                            .trim()
                                            .replaceAll(RegExp(" +"), " "),
                                        start: _start,
                                        stop: _stop,
                                        cat: _catValue,
                                      )
                                    ];

                                    print('[DB] Add first event to the day');
                                  }

                                  DatabaseService(uid: _userId).addEvent(
                                    id,
                                    _eventController.text
                                        .trim()
                                        .replaceAll(RegExp(" +"), " "),
                                    _start,
                                    _stop,
                                    _catValue,
                                  );
                                }
                                else if(type==1) {
                                  String id = argEvent.id;
                                  _events[index].remove(argEvent);

                                  if (_events[index] != null) {
                                    _events[index].add(Event(
                                      id: id,
                                      event: _eventController.text
                                          .trim()
                                          .replaceAll(RegExp(" +"), " "),
                                      start: _start,
                                      stop: _stop,
                                      cat: _catValue,
                                    ));

                                    _events[index].sort((a, b) {
                                      var sa = a.start.hour * 60 + a.start.minute;
                                      var sb = b.start.hour * 60 + b.start.minute;
                                      return sa - sb;
                                    });
                                  } else {
                                    _events[index] = [
                                      Event(
                                        id: id,
                                        event: _eventController.text
                                            .trim()
                                            .replaceAll(RegExp(" +"), " "),
                                        start: _start,
                                        stop: _stop,
                                        cat: _catValue,
                                      )
                                    ];
                                  }

                                  print('[DB] Update event');
                                  DatabaseService(uid: _userId).updateEvent(
                                    id,
                                    _eventController.text
                                        .trim()
                                        .replaceAll(RegExp(" +"), " "),
                                    _start,
                                    _stop,
                                    _catValue,
                                  );
                                }

                                if("${index.toString()}Z"=="${_controller.selectedDay}"){
                                  setState(() {
                                    _selectedEvents=_events[index];
                                  });
                                }
                              }

                              // _start = new DateTime(_start.year, _start.month, _start.day, 12, 0, _start.second, _start.millisecond, _start.microsecond);
                              // _stop = new DateTime(_stop.pyear, _stop.month, _stop.day, 12, 0, _stop.second, _stop.millisecond, _stop.microsecond);
                              Navigator.pop(context, true);
                              // Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(103, 30),
                                primary: Color(0xFFE17262),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5.0))),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                      ],
                    )
                  ])),
              // actions:
                )
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

  _showRoutineDialog(DateTime min,DateTime max) async {
    print(_selectedEvents);
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // title: Center(child:Text(type==0? "Add Event":"Edit Event")),
                content: Container(
                  width: 700.0,
                  height: 500.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xFFFFFF),
                    borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(child:
                            Padding(
                              padding: const EdgeInsets.only(top: 13.0),
                              child: Text("Add Routine Events",
                                  style: GoogleFonts.mali(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  )),
                            )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
                              child: TextField(
                                controller: _eventController,
                                maxLength: 25,
                                decoration: InputDecoration(
                                    labelText: "Event", hintText: "Enter event name",
                                    counterText: '',
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                ),
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
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Start Time"),
                                        SizedBox(
                                            height: 50,
                                            width: 160,
                                            child: CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme: CupertinoTextThemeData(
                                                    dateTimePickerTextStyle: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                child: CupertinoDatePicker(
                                                    initialDateTime: _start,
                                                    mode: CupertinoDatePickerMode.dateAndTime,
                                                    minimumDate: min,
                                                    maximumDate: max,
                                                    use24hFormat: true,
                                                    onDateTimeChanged: (dateTime) {
                                                      print(dateTime);
                                                      setState(() {
                                                        _eventAlert = false;
                                                        _eventAlertText = "";
                                                        _start = dateTime;
                                                      });
                                                    }
                                                )
                                            )
                                        ),
                                      ]
                                  ),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Stop Time"),
                                        SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme: CupertinoTextThemeData(
                                                    dateTimePickerTextStyle: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
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
                                                    }
                                                )
                                            )
                                        ),
                                      ]
                                  ),
                                ]
                            ),
                           Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: DropdownButton<String>(
                                        value: _catValue,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(color: Colors.grey),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black26,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _catValue = newValue;
                                          });
                                          FocusScope.of(context).unfocus();
                                        },
                                        items: [
                                          'Family',
                                          'Friend',
                                          'School',
                                          'Personal',
                                          'Special',
                                          'Other'].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: Icon(Icons.circle, color: Color(catMap[value]), size: 20),
                                                      ),
                                                      Text(value,
                                                            style: GoogleFonts.mali(
                                                              textStyle: TextStyle(
                                                                // color: Color(catMap[value]),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 17,
                                                              ),
                                                            )),
                                                      
                                                    ]),
                                            ),
                                            
                                          );
                                        }).toList(),
                                      ),
                                  ),
                                  
                                  Container(
                                      width: 100.0,
                                      child: TextField(
                                        controller: _repeatController,
                                        maxLength: 2,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            height: 1.6,
                                            color: Colors.black
                                        ),
                                        decoration: InputDecoration(
                                            labelText: "Repeat", hintText: "In weeks",
                                            counterText: '',
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(2),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (text) {
                                          if (text.isEmpty) {
                                            print("Please fill Repeat number");
                                            setState(() {
                                              _eventAlert = true;
                                              _eventAlertText = "Please fill Repeat number";
                                            });
                                          } else {
                                            setState(() {
                                              _repeat=int.parse(text);
                                              _eventAlert = false;
                                              _eventAlertText = "";
                                            });
                                          }
                                        },
                                      ),
                                  ),

                                ],
                              ),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Container(
                                width: 700.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xFFFFFF),
                                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                    child: ListView(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        children: [
                                          ..._addList.map((value) => ListTile(
                                            title:
                                              Container(
                                              width: 700.0,
                                              height: 28.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: const Color(0xFFFFFF),
                                                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                                                  border: Border.all(
                                                    color: Color(weekColor[DateFormat('EEEE').format(value.start)]),
                                                    width: 2.0,
                                                  ),
                                              ),
                                              child: ListView(
                                                shrinkWrap: true,
                                                // padding: const EdgeInsets.all(20.0),
                                                scrollDirection: Axis.horizontal,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 6, left: 6, top: 2),
                                                        child: Icon(Icons.circle, color: Color(catMap[value.cat]), size: 18
                                                        // Color(weekColor[DateFormat('EEEE').format(value.start)])
                                                        ),
                                                      ),
                                                      Text(
                                                            "${value.event} @${time.format(value.start)}-${time.format(value.stop)}",
                                                            style: GoogleFonts.mali(
                                                              textStyle: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                      ),
                                                      SizedBox(
                                                          height: 18.0,
                                                          width: 18.0,
                                                          child: IconButton(
                                                            icon:
                                                            Icon(Icons.delete, color: Colors.black, size: 18.0),
                                                            padding: const EdgeInsets.only(bottom: 50.0),
                                                            onPressed: () {
                                                              setState(() {
                                                                _addList.remove(value);
                                                              });
                                                            },
                                                          ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                        ]
                                    ),
                                ),
                              ),
                            ),
                            Center(
                                child: MaterialButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    DateTime index = new DateTime(
                                      _start.year,
                                      _start.month,
                                      _start.day,
                                      12,
                                      0,
                                      _start.second,
                                      _start.millisecond,
                                      _start.microsecond,
                                    ).toUtc();
                                    DateTime temp = new DateTime(
                                      _start.year,
                                      _start.month,
                                      _start.day,
                                      _stop.hour,
                                      _stop.minute,
                                      _start.second,
                                      _start.millisecond,
                                      _start.microsecond,
                                    );
                                    setState(() {
                                      _stop=temp;
                                    });

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

                                    var md2 = _start.month * 31 + _start.day;

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

                                    if (_addList != null) {
                                      for (Event e in _addList) {

                                        var md1 = e.start.month * 31 + e.start.day;

                                        if(md1!=md2){
                                          continue;
                                        }

                                        var s1 = e.start.hour * 60 + e.start.minute;
                                        var e1 = e.stop.hour * 60 + e.stop.minute;

                                        if ((s2 <= s1 && s1 < e2) ||
                                            (s2 < e1 && e1 <= e2) ||
                                            (s1 <= s2 && e2 <= e1)) {

                                          setState(() {
                                            _eventAlert = true;
                                            _eventAlertText =
                                            "Conflict in list: ${e.event} @${datetime.format(e.start)}-${time.format(e.stop)}";
                                          });
                                          return;
                                        }
                                      }
                                    }
                                    if (_events[index] != null) {
                                      for (Event e in _events[index]) {

                                        var s1 = e.start.hour * 60 + e.start.minute;
                                        var e1 = e.stop.hour * 60 + e.stop.minute;

                                        if ((s2 <= s1 && s1 < e2) ||
                                            (s2 < e1 && e1 <= e2) ||
                                            (s1 <= s2 && e2 <= e1)) {

                                          setState(() {
                                            _eventAlert = true;
                                            _eventAlertText =
                                            "Conflict with ${e.event} @${datetime.format(e.start)}-${time.format(e.stop)}";
                                          });
                                          return;
                                        }
                                      }
                                    }

                                    String id = uuid.v1();
                                    if (_addList != null) {
                                      setState(() {
                                        _addList.add(Event(
                                          id: id,
                                          event: _eventController.text
                                              .trim()
                                              .replaceAll(RegExp(" +"), " "),
                                          start: _start,
                                          stop: _stop,
                                          cat: _catValue,
                                        ));
                                      });


                                      _addList.sort((a, b) {
                                        var mda = a.start.month * 31 + a.start.day;
                                        var mdb = b.start.month * 31 + b.start.day;

                                        var sa = a.start.hour * 60 + a.start.minute;
                                        var sb = b.start.hour * 60 + b.start.minute;

                                        if(mda==mdb){
                                          return sa - sb;
                                        }else{
                                          return mda-mdb;
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _addList = [
                                          Event(
                                            id: id,
                                            event: _eventController.text
                                                .trim()
                                                .replaceAll(RegExp(" +"), " "),
                                            start: _start,
                                            stop: _stop,
                                            cat: _catValue,
                                          )
                                        ];
                                      });
                                    }
                                  },
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Icon(
                                    Icons.add,
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.all(12),
                                  shape: CircleBorder(),
                                )
                            ),
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(103, 30),
                                        primary: Colors.grey,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0))),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      for(int j=0;j<_repeat+1;j++){
                                        for(Event i in _addList) {
                                          DateTime Lstart = i.start.add(
                                              Duration(days: (j * 7)));
                                          DateTime index = new DateTime(
                                            i.start.year,
                                            i.start.month,
                                            (i.start.day + (j * 7)),
                                            12,
                                            0,
                                            i.start.second,
                                            i.start.millisecond,
                                            i.start.microsecond,
                                          ).toUtc();
                                          DateTime Lstop = new DateTime(
                                            i.start.year,
                                            i.start.month,
                                            (i.start.day + (j * 7)),
                                            i.stop.hour,
                                            i.stop.minute,
                                            i.start.second,
                                            i.start.millisecond,
                                            i.start.microsecond,
                                          );

                                          print("repeat ${j + 1}: ${Lstart
                                              .toString()} - ${Lstop
                                              .toString()}");

                                          var s2 = Lstart.hour * 60 +
                                              Lstart.minute;
                                          var e2 = Lstop.hour * 60 +
                                              Lstop.minute;

                                          if (_events[index] != null) {
                                            for (Event e in _events[index]) {
                                              var s1 = e.start.hour * 60 +
                                                  e.start.minute;
                                              var e1 = e.stop.hour * 60 +
                                                  e.stop.minute;

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
                                                  "Conflict with ${e
                                                      .event} @${datetime.format(
                                                      e.start)}-${time.format(
                                                      e.stop)}";
                                                });
                                                return;
                                              }
                                              print(
                                                  "${e.event} ${datetime.format(
                                                      e.start)}-${time.format(
                                                      e.stop)}");
                                            }
                                          }

                                          String id = uuid.v1();
                                          if (_events[index] != null) {
                                            _events[index].add(Event(
                                              id: id,
                                              event: i.event
                                                  .trim()
                                                  .replaceAll(RegExp(" +"), " "),
                                              start: Lstart,
                                              stop: Lstop,
                                              cat: i.cat,
                                            ));

                                            _events[index].sort((a, b) {
                                              var sa = a.start.hour * 60 +
                                                  a.start.minute;
                                              var sb = b.start.hour * 60 +
                                                  b.start.minute;
                                              return sa - sb;
                                            });

                                            print(
                                                '[DB] Add new event to the day');
                                          } else {
                                            _events[index] = [
                                              Event(
                                                id: id,
                                                event: i.event
                                                    .trim()
                                                    .replaceAll(
                                                    RegExp(" +"), " "),
                                                start: Lstart,
                                                stop: Lstop,
                                                cat: i.cat,
                                              )
                                            ];

                                            print(
                                                '[DB] Add first event to the day');
                                          }

                                          DatabaseService(uid: _userId).addEvent(
                                            id,
                                            i.event
                                                .trim()
                                                .replaceAll(RegExp(" +"), " "),
                                            Lstart,
                                            Lstop,
                                            i.cat,
                                          );
                                        }
                                      }
                                      Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(103, 30),
                                        primary: Color(0xFFE17262),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0))),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                ),
                              ],
                            )
                          ])),
                  // actions:
                )
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