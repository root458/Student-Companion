import 'package:flutter/material.dart';
import 'package:student_companion/models/attendance_model.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/attendance/components/attendance_progress.dart';
import 'package:student_companion/screens/attendance/components/attendance_today.dart';
import 'package:student_companion/services/database.dart';


class AttendanceScreenWrapper extends StatefulWidget {

  bool screenToShow;
  User user;

  AttendanceScreenWrapper({this.screenToShow, this.user});

  @override
  _AttendanceScreenWrapperState createState() => _AttendanceScreenWrapperState();
}

class _AttendanceScreenWrapperState extends State<AttendanceScreenWrapper> {

  List<AttendanceModel> subjectAttendancesList = [];

  void updateSubjectAttendanceList(List list) {
    subjectAttendancesList = list;
  }

  // List containing subjects
  var subjects = [];



  @override
  Widget build(BuildContext context) {

    if (widget.screenToShow) {



      return StreamBuilder<List>(
          stream: DatabaseService(uid: widget.user.uid).userSubjects,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              subjects = snapshot.data;
              return AttendanceToday(user: widget.user,subjectAttendancesList: subjectAttendancesList, subjects: subjects,);
            }
            else {
              return AttendanceToday(user: widget.user,subjectAttendancesList: subjectAttendancesList,  subjects: subjects,);
            }

          }
      );
      // return AttendanceToday(user: widget.user,subjectAttendancesList: subjectAttendancesList,);
    }
    else {
      return StreamBuilder<List>(
        stream: DatabaseService(uid: widget.user.uid).userSubjects,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            subjects = snapshot.data;
            return AttendanceProgress(user: widget.user,updateSubjectAttendanceList: updateSubjectAttendanceList, subjects: subjects,);
          }
          else {
            return AttendanceProgress(user: widget.user,updateSubjectAttendanceList: updateSubjectAttendanceList,subjects: subjects,);
          }

        }
        );
    }


  }
}


