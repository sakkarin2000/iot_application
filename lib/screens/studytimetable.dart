import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_application/model/event.dart';
import 'package:iot_application/shared/constant.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class StudyTimetable extends StatefulWidget {
  @override
  _StudyTimetableState createState() => _StudyTimetableState();
}

class _StudyTimetableState extends State<StudyTimetable> {

  // Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController;
  TextEditingController _repeatController;
  DateTime _start = DateTime.now();
  DateTime _stop = DateTime.now();
  final time = new DateFormat('HH:mm');
  bool _eventAlert = false;
  String _eventAlertText = "";
  // String _userId;
  List<Event> myEventList;
  var uuid = Uuid();

  Map<String, List<dynamic>> weekMap = {
    "Sunday": [],
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
  };
  Map<Event, String> modifyMap={};

  int _repeat=0;
  DateTime _startDate=DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController();
    _repeatController=TextEditingController();
    _repeat=0;
    weekMap = {
      "Sunday": [],
      "Monday": [],
      "Tuesday": [],
      "Wednesday": [],
      "Thursday": [],
      "Friday": [],
      "Saturday": [],
    };
  }

  List<Item> _days = <Item>[
    Item(
        headerValue: 'Monday',
        expandedValue: 'event on Monday',
        color: Colors.amber[200]),
    Item(
        headerValue: 'Tuesday',
        expandedValue: 'event on Tuesday',
        color: Colors.purpleAccent[100]),
    Item(
        headerValue: 'Wednesday',
        expandedValue: 'event on Wednesday',
        color: Colors.green[100]),
    Item(
        headerValue: 'Thursday',
        expandedValue: 'event on Thursday',
        color: Colors.orange[200]),
    Item(
        headerValue: 'Friday',
        expandedValue: 'event on Friday',
        color: Colors.lightBlue[100]),
    Item(
        headerValue: 'Saturday',
        expandedValue: 'event on Saturday',
        color: Colors.purple[200]),
    Item(
        headerValue: 'Sunday',
        expandedValue: 'event on Sunday',
        color: Colors.red[200]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.local_library_outlined,
                      size: 40,
                    ),
                  ),
                  Text('Study Timetable',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Color(0xFF30415E),
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                height: 530,
                child: SingleChildScrollView(
                    child: Container(
                        width: 310,
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _days[index].isExpanded = !isExpanded;
                            });
                          },
                          children: _days.map<ExpansionPanel>((Item item) {
                            return ExpansionPanel(
                              backgroundColor: item.color,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return
                                  ListTile(
                                  title: Text(item.headerValue,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                );

                              },
                              body: ListTile(
                                title: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(20.0),
                                    children: [
                                      ...weekMap[item.headerValue].map((value) => ListTile(
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
                                                children: <Widget>[
                                                  Text(
                                                      "${value.event} @${time.format(value.start)}-${time.format(value.stop)}",
                                                      style: GoogleFonts.mali(
                                                        textStyle: TextStyle(
                                                          // color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                  ),
                                                  IconButton(
                                                    icon:
                                                    Icon(Icons.delete, color: Colors.black),
                                                    onPressed: () {
                                                      setState(() {
                                                        weekMap[DateFormat('EEEE').format(value.start)].remove(value);
                                                      });
                                                      if(modifyMap[value]!=null){
                                                        if(modifyMap[value]=="add"){
                                                          modifyMap.remove(value);
                                                        }else{
                                                        }
                                                      }else{
                                                        modifyMap[value]="remove";
                                                      }
                                                      print('click delete');
                                                      // setState(() {
                                                      //   _eventController.text = value.event;
                                                      //   _eventAlert = false;
                                                      //   _eventAlertText = "";
                                                      //   _start = value.start;
                                                      //   _stop = value.stop;
                                                      //   // _catValue = value.cat;
                                                      // });
                                                      // _showAddDialog(1,value);
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

                                // Text(item.expandedValue),
                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        ))),
              ),
              ElevatedButton(
                onPressed: () {

                  DateTime tem1=new DateTime(
                    _startDate.year,
                    _startDate.month,
                    _startDate.day,
                    12,
                    0,
                    _startDate.second,
                    _startDate.millisecond,
                    _startDate.microsecond,
                  );

                  _eventController.clear();
                  setState(() {
                    _eventAlert = false;
                    _eventAlertText = "";
                    _start = tem1;
                    _stop = tem1.add(Duration(hours:1));
                    // _addList=[];
                  });

                  DateTime minDate=_startDate;
                  DateTime maxDate=minDate.add(Duration(days:6));
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
                // onPressed: () {
                //   showDialog(
                //     context: context,
                //     builder: (context) => SimpleDialog(
                //       title: ListTile(
                //         title: Center(
                //           child: Text(
                //             'Dialog',
                //             style: TextStyle(
                //                 fontSize: 22, fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // },
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
                child: 
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xFF30415E)),
                      
                      Text(
                        'Subject',
                        style: TextStyle(
                            color: Color(0xFF30415E),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'mali'),
                      ),
                      ],
                      ),
                    ),
                
              )
            ],
          ),
          decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/category.png"),
                  fit: BoxFit.cover,
                ),
              ),
        ),
      ),
    );
  }

  _showRoutineDialog(DateTime min, DateTime max) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // title: Center(child:Text(type==0? "Add Event":"Edit Event")),
                content: Container(
                  width: 700.0,
                  height: 250.0,
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
                            Text("Add Subject",
                                style: GoogleFonts.mali(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ))
                            ),
                            TextField(
                              controller: _eventController,
                              maxLength: 25,
                              decoration: InputDecoration(
                                labelText: "Subject", hintText: "Enter subject name",
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                              ),
                              onChanged: (text) {
                                if (text.isEmpty) {
                                  print("Please fill subject name");
                                  setState(() {
                                    _eventAlert = true;
                                    _eventAlertText = "Please fill subject name";
                                  });
                                } else if (text.trim().isEmpty) {
                                  print("Subject name cannot be blank");
                                  setState(() {
                                    _eventAlert = true;
                                    _eventAlertText = "Subject name cannot be blank";
                                  });
                                } else {
                                  setState(() {
                                    _eventAlert = false;
                                    _eventAlertText = "";
                                  });
                                }
                              },
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
                                      String day=DateFormat('EEEE').format(_start);
                                      String cat="School";

                                      DateTime Lstart=_start;
                                      DateTime Lstop = new DateTime(
                                        _start.year,
                                        _start.month,
                                        _start.day,
                                        _stop.hour,
                                        _stop.minute,
                                        _start.second,
                                        _start.millisecond,
                                        _start.microsecond,
                                      );

                                      var s2 = Lstart.hour * 60 +
                                          Lstart.minute;
                                      var e2 = Lstop.hour * 60 +
                                          Lstop.minute;

                                      if (weekMap[day]!= null) {
                                        for (Event e in weekMap[day]) {
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
                                                  .event} @${time.format(
                                                  e.start)}-${time.format(
                                                  e.stop)}";
                                            });
                                            return;
                                          }
                                          // print(
                                          //     "${e.event} ${time.format(
                                          //         e.start)}-${time.format(
                                          //         e.stop)}");
                                        }
                                      }

                                      String id = uuid.v1();
                                      Event temp=new Event(
                                        id: id,
                                        event: _eventController.text
                                            .trim()
                                            .replaceAll(RegExp(" +"), " "),
                                        start: Lstart,
                                        stop: Lstop,
                                        cat: cat,
                                        isTimeTable: true,
                                      );
                                      if (weekMap[day] != null) {
                                        weekMap[day].add(temp);
                                        if(modifyMap[temp]!=null){
                                          modifyMap[temp]="add";
                                        }
                                        weekMap[day].sort((a, b) {
                                          var sa = a.start.hour * 60 +
                                              a.start.minute;
                                          var sb = b.start.hour * 60 +
                                              b.start.minute;
                                          return sa - sb;
                                        });
                                      } else {
                                        weekMap[day]=[temp];
                                        if(modifyMap[temp]!=null){
                                          modifyMap[temp]="add";
                                        }
                                      }

                                      //////////////////////////////////////////////////////////////////////////////////Add event

                                      // for(int j=0;j<_repeat+1;j++){
                                      //
                                      //   DateTime Lstart=_start.add(Duration(days: (j * 7)));
                                      //
                                      //   DateTime Lstop = new DateTime(
                                      //     _start.year,
                                      //     _start.month,
                                      //     (_start.day + (j * 7)),
                                      //     _stop.hour,
                                      //     _stop.minute,
                                      //     _start.second,
                                      //     _start.millisecond,
                                      //     _start.microsecond,
                                      //   );

                                        // DateTime index = new DateTime(
                                        //   _start.year,
                                        //   _start.month,
                                        //   (_start.day + (j * 7)),
                                        //   12,
                                        //   0,
                                        //   _start.second,
                                        //   _start.millisecond,
                                        //   _start.microsecond,
                                        // ).toUtc();

                                          // print("repeat ${j + 1}: ${Lstart
                                          //     .toString()} - ${Lstop
                                          //     .toString()}");

                                          // DatabaseService(uid: _userId).addEvent(
                                          //   id,
                                          //   _eventController.text
                                          //       .trim()
                                          //       .replaceAll(RegExp(" +"), " "),
                                          //   Lstart,
                                          //   Lstop,
                                          //   cat,
                                          // );
                                      //   }
                                      // }

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
                )
            );
          });
        }).then((event) {
      if (event == null) return;
      if (event) {
      } else {}
    });
    String day=DateFormat('EEEE').format(_start);
    setState(() {
      weekMap[day]=weekMap[day];
    });
  }

}

class Item {
  Item(
      {this.expandedValue,
      this.headerValue,
      this.isExpanded = false,
      this.color});

  String expandedValue;
  String headerValue;
  bool isExpanded;
  Color color;
}
