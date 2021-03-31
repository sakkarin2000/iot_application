import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({
    @required this.loginState,
    @required this.email,
    @required this.startLoginFlow,
    @required this.verifyEmail,
    @required this.signInWithEmailAndPassword,
    @required this.cancelRegistration,
    @required this.registerAccount,
    @required this.signOut,
  });

  final ApplicationLoginState loginState;
  final String email;
  final void Function() startLoginFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                child: Text("Let's Go"),
                onPressed: () {
                  startLoginFlow();
                },
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Invalid email', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email,
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            registerAccount(
                email,
                displayName,
                password,
                (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return
            // HomePage();

            Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                child: Text('LOGOUT'),
                onPressed: () {
                  signOut();
                },
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EmailForm extends StatefulWidget {
  EmailForm({@required this.callback});
  final void Function(String email) callback;
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 160, left: 55, right: 55),
                  child: TextFormField(
                    controller: _controller,
                    style: TextStyle(fontSize: 18),
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: Text('NEXT'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({
    @required this.registerAccount,
    @required this.cancel,
    @required this.email,
  });
  final String email;
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 160, left: 55, right: 55, bottom: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _displayNameController,
                    style: TextStyle(fontSize: 18),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Name Surname',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your account name';
                      }
                      return null;
                    },
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: Text('CANCEL'),
                      ),
                      SizedBox(width: 25),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.registerAccount(
                              _emailController.text,
                              _displayNameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Text('SIGN UP'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  PasswordForm({
    @required this.login,
    @required this.email,
  });
  final String email;
  final void Function(String email, String password) login;
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 160, left: 55, right: 55),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your email address to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 55, right: 55),
                  child: TextFormField(
                    controller: _passwordController,
                    style: TextStyle(fontSize: 18),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Text('SIGN IN'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
    hexColor(String colorhexcode) {
      String colornew = '0xff' + colorhexcode;
      colornew = colornew.replaceAll('#', '');
      int colorint = int.parse(colornew);
      return colorint;
    }

    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0),
    ); //for bottom part

    var logo = [
      Text('I',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(hexColor('#BED4DF')),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      Text('o',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(hexColor('#CCADA5')),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      Text('T',
          style: GoogleFonts.mali(
            textStyle: TextStyle(
              color: Color(hexColor('#FFB9A3')),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
    ];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(hexColor('#30415E'))),
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: <Color>[Color(0xff153970), Color(0xff153970)]),
                    color: Color(hexColor('#153970'))),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(padding: EdgeInsets.all(8.0)),
                        // child: Image.asset('name')
                      ),
                      Text('Name',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                )),
            CustomListTile(Icons.account_box, 'Profile', () => {}),
            CustomListTile(Icons.calendar_today, 'My Schedule', () => {}),
            CustomListTile(Icons.category, 'Categories', () => {}),
            CustomListTile(Icons.report, 'Report Problem', () => {}),
            CustomListTile(Icons.settings, 'Change password', () => {}),
            CustomListTile(Icons.logout, 'Logout', () => {}),
          ],
        ),
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
                          color: Color(hexColor('#30415E')),
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      )),
                  Text('Your Event',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Color(hexColor('#30415E')),
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
              color: Color(hexColor('#EFF4FF')),
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
                        color: Color(hexColor('#153970')),
                        fontWeight: FontWeight.w700),
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                      color: Color(hexColor('#153970')),
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
              decoration: BoxDecoration(
                  color: Color(hexColor('#153970')), borderRadius: radius),
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
                          child: Text("Today's tasks",
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
                        title:
                            Text("${value.event} @${value.start}-${value.stop}",
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
                            hintText: "Enter activity name")),
                    TextField(
                        controller: _startController,
                        decoration: InputDecoration(
                            labelText: "Start time",
                            hintText: "Enter start time")),
                    TextField(
                        controller: _stopController,
                        decoration: InputDecoration(
                            labelText: "Stop time",
                            hintText: "Enter stop time"))
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
                    Navigator.pop(context, false);
                    // Navigator.pop(null);
                  },
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    if (_startController.text.isEmpty)
                      _startController.text = '12.00';
                    if (_stopController.text.isEmpty)
                      _stopController.text = '13.00';
                    if (_events[_controller.selectedDay] != null) {
                      _events[_controller.selectedDay].add(Event(
                          _eventController.text,
                          _startController.text,
                          _stopController.text));
                    } else {
                      _events[_controller.selectedDay] = [
                        Event(_eventController.text, _startController.text,
                            _stopController.text)
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
      } else {}
    });
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }
}

class Event {
  String event;
  String start;
  String stop;

  Event(String x, String y, String z) {
    this.event = x;
    this.start = y;
    this.stop = z;
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Color(0xffBED4DF),
        onTap: onTap,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(text,
                      style: TextStyle(color: Color(0xff153970), fontSize: 18)),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
