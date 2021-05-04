import 'package:flutter/material.dart';
import 'package:iot_application/shared/constant.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyTimetable extends StatefulWidget {
  @override
  _StudyTimetableState createState() => _StudyTimetableState();
}

class _StudyTimetableState extends State<StudyTimetable> {
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
                                return ListTile(
                                  title: Text(item.headerValue,
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                );
                              },
                              body: ListTile(
                                title: Text(item.expandedValue),
                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        ))),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: ListTile(
                        title: Center(
                          child: Text(
                            'Dialog',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
