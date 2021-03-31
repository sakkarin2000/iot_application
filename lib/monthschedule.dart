import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _startController = TextEditingController();
    _stopController = TextEditingController();
    _events = {};
    _selectedEvents = [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: '',
              },
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onDaySelected: (date, events, event2) {
                setState(() {
                  _selectedEvents = events;
                  print(events.toString());
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        // borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.circle
                    ),
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
                        shape: BoxShape.circle
                ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                )),
              ),
              calendarController: _controller,
            ),
            ..._selectedEvents.map((value) => ListTile(
              title: Text("${value.event} @${value.start}-${value.stop}"),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  labelText: "Activity",
                  hintText: "Enter activity name"
                )
              ),
              TextField(
                controller: _startController,
                  decoration: InputDecoration(
                      labelText: "Start time",
                      hintText: "Enter start time"
                  )
              ),
              TextField(
                controller: _stopController,
                  decoration: InputDecoration(
                      labelText: "Stop time",
                      hintText: "Enter stop time"
                  )
              )
            ]
          )),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                if (_events[_controller.selectedDay] != null) {
                  _events[_controller.selectedDay].add('temporary fix');
                  _events[_controller.selectedDay].removeLast();
                } else {
                  _events[_controller.selectedDay] = [
                    'temporary fix'
                  ];
                  _events[_controller.selectedDay].removeLast();
                }
                Navigator.pop(context, false);
                // Navigator.pop(null);
              },
            ),
            TextButton (
              child: Text("Save"),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                if (_startController.text.isEmpty) _startController.text='12.00';
                if (_stopController.text.isEmpty) _stopController.text='13.00';
                if (_events[_controller.selectedDay] != null) {
                  _events[_controller.selectedDay]
                      .add(Event(_eventController.text,_startController.text,_stopController.text));
                } else {
                  _events[_controller.selectedDay] = [
                    Event(_eventController.text,_startController.text,_stopController.text)
                  ];
                }
                _eventController.clear();
                _startController.clear();
                _stopController.clear();
                Navigator.pop(context, true);
                // Navigator.pop(context);
              },
            )
          ],
        )).then((event) {
            if (event == null) return;
            if (event) {

            } else {

            }
        });
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }
}

class Event{
  String event;
  String start;
  String stop;

  Event(String x, String y, String z) {
    this.event = x;
    this.start = y;
    this.stop = z;
  }
}