import 'package:flutter/material.dart';
import 'package:iot_application/widgets/hamburger.dart';
import 'package:google_fonts/google_fonts.dart';

class CatPageKa extends StatefulWidget {
  @override
  _CatPageKaState createState() => _CatPageKaState();
}

class _CatPageKaState extends State<CatPageKa> {
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
      home: Scaffold(
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
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 25, bottom: 15),
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
                    ],
                  ),
                ),
                Column(
                  children: [
                    CatBox(
                        icon: Icons.family_restroom_rounded,
                        label: "Family",
                        usage: '1',
                        color: Color(0xffFECD4C)),
                    CatBox(
                        icon: Icons.group,
                        label: "Friend",
                        usage: '3',
                        color: Color(0xff58DCE4)),
                    CatBox(
                        icon: Icons.school,
                        label: "School",
                        usage: '2',
                        color: Color(0xffE17262)),
                    CatBox(
                        icon: Icons.tag_faces_rounded,
                        label: "Personal",
                        usage: '4',
                        color: Color(0xff9776F8)),
                    CatBox(
                        icon: Icons.favorite_rounded,
                        label: "Special",
                        usage: '2',
                        color: Color(0xffFFB9A3)),
                    CatBox(
                        icon: Icons.all_inclusive_sharp,
                        label: "Other",
                        usage: '3',
                        color: Color(0xffE5A4ED)),
                  ],
                ),
              ]),
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

class CatBox extends StatelessWidget {
  final icon;
  final label;
  final usage;
  final color;
  CatBox(
      {@required this.icon,
      @required this.label,
      @required this.usage,
      @required this.color});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: 310,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Card(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Icon(
                              icon,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 173,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              width: 33,
                              height: 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white.withOpacity(0.9)),
                              child: Text(
                                usage,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )),
          ),
        ),
      );
}
