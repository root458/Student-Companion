import 'package:flutter/material.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/attendance/components/attendance_screen_wrapper.dart';
import 'package:student_companion/constants.dart';


class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  // Data specified here
  bool showToday = false;
  String barTitle = 'Attendance Progress';
  void changePage() {
    setState(() {
      showToday = !showToday;
      if (showToday) {
        barTitle = 'Attendance Today';
      }
      else{
        barTitle = 'Attendance Progress';
      }
    });
  }


  // Data
  Map data = {};

  User user;


  @override
  Widget build(BuildContext context) {

    // Receiving the uid sent form home page in a map
    data = ModalRoute.of(context).settings.arguments;

    user = data['userObject'];


    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
            barTitle,
            style: TextStyle(
              fontFamily: 'MontserratThin',
              fontWeight: FontWeight.bold,
            ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, defaultPadding, 0.0),
            icon: Icon(
              Icons.swap_horiz,
              color: Colors.white,
            ),
            onPressed: () {
              changePage();
            },
          )
        ],
      ),
      body: AttendanceScreenWrapper(screenToShow: showToday, user: user,),
    );
  }
}





