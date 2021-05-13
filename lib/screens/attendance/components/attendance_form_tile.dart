import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/attendance_model.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/services/database.dart';

class AttendanceFormTile extends StatefulWidget {

  String subject;

  List filledSubjects;

  User user;

  AttendanceModel attendanceModel;

  AttendanceFormTile({this.subject, this.attendanceModel, this.user, this.filledSubjects});

  @override
  _AttendanceFormTileState createState() => _AttendanceFormTileState();
}

class _AttendanceFormTileState extends State<AttendanceFormTile> {

  bool activityWasAttended = false;
  bool didNotGo = false;
  bool activityWasHeld = false;
  bool alreadyResponded = false;
  bool heldResponded = false;
  bool attendedResponded = false;
  bool pressedNo = false;
  String feedback = '';

  int currentHeld;
  int currentAttended;


  @override
  Widget build(BuildContext context) {
    return Card(
        color: white,
        shadowColor: lightGrey,
        elevation: 7.0,
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    margin: EdgeInsets.fromLTRB(5.0, 16.0, 5.0, 0.0),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.subject,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 5.0,),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                'Was it held?',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              ),
              SizedBox(width: 5.0,),
              Expanded(
                flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: activityWasHeld ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              if (!pressedNo) {
                                if (!heldResponded) {
                                  setState(() {
                                    heldResponded = true;
                                    activityWasHeld = true;
                                    // Other actions
                                  });
                                }

                              }
                            }
                     ),
                      SizedBox(width: 5.0,),
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: pressedNo ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            if (!heldResponded) {

                              // Add this subject to attended
                              var filledSubjectsSet = widget.filledSubjects.toSet();
                              filledSubjectsSet.add(widget.subject);
                              widget.filledSubjects = filledSubjectsSet.toList();
                              await DatabaseService(uid: widget.user.uid).updateFilled(widget.filledSubjects);

                              setState(() {
                                heldResponded = true;
                                activityWasHeld = false;
                                pressedNo  = true;
                                alreadyResponded = true;
                                feedback = 'Response taken for this subject';

                                // Actions
                                // Nothing happens

                              });
                            }



                          }
                      ),
                    ],
                  )
              )
            ],
          ),
          SizedBox(height: 5.0,),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Did you attend?',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(width: 5.0,),
              Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: activityWasAttended ? Colors.green : Colors.grey,
                          ),
                          onPressed: () async {
                            if (!alreadyResponded) {
                              if (activityWasHeld) {
                                if (!attendedResponded) {

                                  // Actions
                                  int newHeld = widget.attendanceModel.held + 1;
                                  await DatabaseService(uid: widget.user.uid).updateNumberHeld(widget.subject, newHeld);

                                  int newAttended = widget.attendanceModel.attended + 1;
                                  await DatabaseService(uid: widget.user.uid).updateNumberAttended(widget.subject, newAttended);


                                  // Add this subject to attended
                                  var filledSubjectsSet = widget.filledSubjects.toSet();
                                  filledSubjectsSet.add(widget.subject);
                                  widget.filledSubjects = filledSubjectsSet.toList();
                                  await DatabaseService(uid: widget.user.uid).updateFilled(widget.filledSubjects);

                                  setState(() {
                                    attendedResponded = true;
                                    alreadyResponded = true;
                                    activityWasAttended = true;
                                    feedback = 'Response taken for this subject';

                                  });
                                }



                              }
                            }

                          }
                      ),
                      SizedBox(width: 5.0,),
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color:  didNotGo ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            if (!alreadyResponded) {
                              if (activityWasHeld) {
                                if (!attendedResponded) {

                                  int newHeld = widget.attendanceModel.held + 1;
                                  await DatabaseService(uid: widget.user.uid).updateNumberHeld(widget.subject, newHeld);

                                  // Add this subject to attended
                                  var filledSubjectsSet = widget.filledSubjects.toSet();
                                  filledSubjectsSet.add(widget.subject);
                                  widget.filledSubjects = filledSubjectsSet.toList();
                                  await DatabaseService(uid: widget.user.uid).updateFilled(widget.filledSubjects);

                                  setState(() {
                                    attendedResponded = true;
                                    alreadyResponded = true;
                                    didNotGo = true;
                                    feedback = 'Response taken for this subject';

                                    // Actions

                                  });
                                }

                              }
                            }

                          }
                      ),
                    ],
                  )
              )
            ],
          ),
          Text(
            feedback,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.green
            ),
          ),
        ],
      ),
    ),
    );


  }
}
