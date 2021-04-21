import 'package:flutter/material.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:google_fonts/google_fonts.dart';

class CatPageKa extends StatelessWidget {
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
      home: CatPage(),
    );
  }
}

class CatPage extends StatefulWidget {
  @override
  _CatPageState createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    );

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
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Container(
                margin: EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories',
                        style: GoogleFonts.mali(
                          textStyle: TextStyle(
                            color: Color(0xFF30415E),
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        )),
                    Text('Of Events',
                        style: GoogleFonts.mali(
                          textStyle: TextStyle(
                            color: Color(0xFF30415E),
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        )),
                   
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: Color(0xffFECD4C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.family_restroom_rounded,size: 30,)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "Family",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:164),
                                            child: Text(
                                              '1',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xff58DCE4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.group,size:30)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "Friend",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:160),
                                            child: Text(
                                              '2',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xffE17262),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.school,size: 30,)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "School",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:160),
                                            child: Text(
                                              '3',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xff9776F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.tag_faces_rounded,size:30)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "Personal",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:135),
                                            child: Text(
                                              '4',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xffFFB9A3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.favorite_rounded,size: 30,)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "Special",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:150),
                                            child: Text(
                                              '5',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color(0xffE5A4ED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Align(
                                           alignment: Alignment.centerLeft,
                                            child: Icon(
                                                Icons.all_inclusive_sharp,size:30)),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(
                                              "Other",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ))),
                                    Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(left:165),
                                            child: Text(
                                              '6',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            )))
                                  ],
                                )
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
