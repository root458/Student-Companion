import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/attendance_model.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/attendance/components/attendance_form_tile.dart';
import 'package:student_companion/services/database.dart';

class AttendanceToday extends StatefulWidget {

  User user;

  List subjects;

  List<AttendanceModel> subjectAttendancesList;

  AttendanceToday({this.user, this.subjectAttendancesList, this.subjects});

  @override
  _AttendanceTodayState createState() => _AttendanceTodayState();
}

class _AttendanceTodayState extends State<AttendanceToday> {

  // Map to store the subjects and the days
  Map subjectsOnDaysNow = {};
  
  DateTime now = DateTime.now();
  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  List subjectsForToday = [];
  List subjectsForTodayTemp = [];
  List filledSubjects = [];
  List<AttendanceModel> subjectAttendancesListNew = [];
  List backUpSubjects = ['Loading...'];
  
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: StreamBuilder<Map>(
        stream: DatabaseService(uid: widget.user.uid).subjectsOnDays,
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            subjectsOnDaysNow = snapshot.data;

            subjectsForTodayTemp = subjectsOnDaysNow[days[DateTime.now().weekday]];

            print(subjectsForTodayTemp);
            // Remove subjects not in subjects list

            for (int i = 0; i < subjectsForTodayTemp.length; i++) {
              if(widget.subjects.contains(subjectsForTodayTemp[i])) {
                var subjectsForTodaySet = subjectsForToday.toSet();
                subjectsForTodaySet.add(subjectsForTodayTemp[i]);
                subjectsForToday = subjectsForTodaySet.toList();
              }

            }

            print(subjectsForToday);

            if (subjectsForToday.length > 0) {
              return StreamBuilder<List>(
                stream: DatabaseService(uid: widget.user.uid).filledSubjects,
                builder: (context, snapshot) {

                  if (snapshot.hasData) {

                    filledSubjects = snapshot.data;

                    print('Filled ${filledSubjects}');

                    // Remove subjects in filled subjects

                    for (int i = 0; i < subjectsForToday.length; i++) {
                      if(filledSubjects.contains(subjectsForToday[i])) {
                        var subjectsForTodaySet = subjectsForToday.toSet();
                        subjectsForTodaySet.remove(subjectsForToday[i]);
                        subjectsForToday = subjectsForTodaySet.toList();
                      }

                    }

                    print('For today ${subjectsForToday}');

                    // Give some order for the subjects
                    for (int i = 0; i < subjectsForToday.length; i++ ) {
                      for (int j = 0; j < widget.subjectAttendancesList.length; j++ ) {
                        if (widget.subjectAttendancesList[j].subject == subjectsForToday[i]) {
                          subjectAttendancesListNew.add(widget.subjectAttendancesList[j]);
                        }
                      }
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: subjectsForToday.length,
                        itemBuilder: (context, index) {

                          try {
                            return AttendanceFormTile(subject: subjectsForToday[index],attendanceModel: subjectAttendancesListNew[index],user: widget.user, filledSubjects: filledSubjects,);
                          } catch (e) {
                            return Container();
                          }

                        });
                  }
                  else {
                    return Container();
                  }
                },
              );
            }
            else{
              return Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(
                  'None of the subjects you have appears on your timetable today :-)',
                  style: TextStyle(
                    fontFamily: 'MontserratThin',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),
              );
            }
          }

          else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: backUpSubjects.length,
                itemBuilder: (context, index) {
                  return AttendanceFormTile(subject: backUpSubjects[index],);
                });

          }



        },

      ),

    );
  }
}
