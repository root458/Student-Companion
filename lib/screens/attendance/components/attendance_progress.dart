import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/attendance_model.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/attendance/components/attendance_tile.dart';
import 'package:student_companion/services/database.dart';


class AttendanceProgress extends StatefulWidget {

  User user;
  
  List subjects;

  Function updateSubjectAttendanceList;

  AttendanceProgress({this.user, this.updateSubjectAttendanceList, this.subjects});

  @override
  _AttendanceProgressState createState() => _AttendanceProgressState();
}

class _AttendanceProgressState extends State<AttendanceProgress> {

  // Data Here
  List<AttendanceModel> subjectAttendancesList = [];



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: widget.user.uid).userAttendance,
        builder: (context, snapshot) {

          QuerySnapshot subjectAttendances = snapshot.data;

          if (snapshot.hasData) {

            // Iterate and retrieve data
            subjectAttendancesList.clear();
            for (var doc in subjectAttendances.documents) {
              if (widget.subjects.contains(doc.documentID) ) {
                var inst = AttendanceModel(subject: doc.documentID, held: doc.data['held'], attended: doc.data['attended']);
                var subjectAttendancesSet = subjectAttendancesList.toSet();
                subjectAttendancesSet.add(inst);
                subjectAttendancesList = subjectAttendancesSet.toList();
              }
            }

            widget.updateSubjectAttendanceList(subjectAttendancesList);

          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: subjectAttendancesList.length,
            itemBuilder: (context, index) {
              return AttendanceTile(attendance: subjectAttendancesList[index],);
            },
          );

        },

      )
    );
  }
}
