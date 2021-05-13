import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/services/database.dart';


// ignore: must_be_immutable
class AddActivityForm extends StatefulWidget {

  User user;
  Function addActivity;
  Map subjectsOnDays;

  AddActivityForm({this.user, this.addActivity, this.subjectsOnDays});

  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  
  String representNum(int num) {
    if (num < 10) {
      return '0'+num.toString();
    }
    else{
      return num.toString();
    }
  }

  // Form Key to determine validation
  final _formkey = GlobalKey<FormState>();

  // Form values
  String _currentSubject;
  String _currentDayOfWeek;
  TimeOfDay _currentStartTime;
  TimeOfDay _currentStopTime;

  String timeError = '';
  bool changedSubject = false;

  // Data
  // List containing subjects
  var subjectsAlt = ['Populate Your Subjects List'];
  var subjects = [];

  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  List dayOfWeekActivities = [];

  @override
  void initState() {
    // Implement initState
    super.initState();
    _currentStartTime = TimeOfDay.now();
    _currentStopTime = TimeOfDay.now();
    _currentDayOfWeek = days[0];
  }


  @override
  Widget build(BuildContext context) {

    void _pickStartTime() async {
      // Getting the time from picker
      TimeOfDay timeFromPicker = await showTimePicker(
        helpText: 'PICK STARTING TIME',
          context: context,
          initialTime: _currentStartTime,
      );

      if (timeFromPicker != null) {
        setState(() {
          _currentStartTime = timeFromPicker;
        });
      }
    }

    void _pickStopTime() async {
      // Getting the time from picker
      TimeOfDay timeFromPicker = await showTimePicker(
        helpText: 'PICK STOPPING TIME',
        context: context,
        initialTime: _currentStopTime,
      );

      if (timeFromPicker != null) {
        setState(() {
          _currentStopTime = timeFromPicker;
        });
      }
    }



    return StreamBuilder<List>(
      stream: DatabaseService(uid: widget.user.uid).userSubjects,
      builder: (context, snapshot) {

        subjects = snapshot.data;

        if (subjects.length < 1) {
          subjects = subjectsAlt;
        }
        else {
          if (!changedSubject) {
            _currentSubject = subjects[0];
          }
        }

        if (snapshot.hasData) {
          return Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                      'ADD ACTIVITY TO YOUR TIMETABLE',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )
                  ),
                ),
                SizedBox(height: 5.0,),
                // Dropdown Subject
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: 'SUBJECT',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: darkGrey
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: lightBlue)
                      )
                    ),
                  value: _currentSubject ?? subjects[0],
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text('$subject'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentSubject = val;
                      changedSubject = true;
                    });
                  },
                ),
                SizedBox(height: 5.0,),
                // Time Picker START TIME
                ListTile(
                  title: Text(
                      'PICK STARTING TIME: ${representNum(_currentStartTime.hour)}:${representNum(_currentStartTime.minute)}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                  onTap: _pickStartTime,
                ),
                // Time Picker STOP TIME
                ListTile(
                  title: Text(
                    'PICK STOPPING TIME: ${representNum(_currentStopTime.hour)}:${representNum(_currentStopTime.minute)}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: Icon(Icons.edit),
                  onTap: _pickStopTime,
                ),
                // Dropdown Day of the week
                DropdownButtonFormField(
                  decoration:  InputDecoration(
                      labelText: 'DAY OF THE WEEK',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: darkGrey
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: lightBlue)
                      )
                  ),
                  value: _currentDayOfWeek ?? days[0],
                  items: days.map((day) {
                    return DropdownMenuItem(
                      value: day,
                      child: Text('$day'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentDayOfWeek = val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                Text(
                  timeError,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20.0,),
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService(uid: widget.user.uid).userTimetable,
                  builder: (context, snapshot) {

                    QuerySnapshot timetableDays = snapshot.data;

                    return Container(
                      height: 40.0,
                      child: GestureDetector(
                        onTap: () async {

                          if (_formkey.currentState.validate()) {

                            // Confirm that subject is not null and not populate subjects
                            if (_currentSubject != null && _currentSubject != 'Populate Your Subjects List') {

                              // Validate the times chosen
                              var now = DateTime.now();
                              DateTime start = DateTime(now.year, now.month, now.day, _currentStartTime.hour, _currentStartTime.minute);
                              DateTime stop = DateTime(now.year, now.month, now.day, _currentStopTime.hour, _currentStopTime.minute);
                              if (stop.isAfter(start)) {

                                // Actions if True

                                Map<dynamic, dynamic> activity = {
                                  'title': _currentSubject,
                                  'startTime': [_currentStartTime.hour, _currentStartTime.minute],
                                  'stopTime': [_currentStopTime.hour, _currentStopTime.minute],
                                  'date':[now.year, now.month, now.day],
                                  'day': _currentDayOfWeek
                                };

                                if (snapshot.hasData) {

                                  for (var doc in timetableDays.documents) {
                                    if (doc.documentID == _currentDayOfWeek) {
                                      dayOfWeekActivities = doc.data[_currentDayOfWeek];

                                      var activitiesSet = dayOfWeekActivities.toSet();
                                      activitiesSet.add(activity);
                                      dayOfWeekActivities = activitiesSet.toList();
                                      await DatabaseService(uid: widget.user.uid).updateDayActivities(_currentDayOfWeek, dayOfWeekActivities);
                                    }
                                  }

                                }


                                await widget.addActivity();

                                Navigator.pop(context);
                              }
                              else {
                                setState(() {
                                  timeError = 'Please check your Start and Stop Times';
                                });
                              }


                            }


                          }

                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.blue,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    );

                  },

                ),

              ],
            ),
          );
        }

        else {
          return Container();
        }

      },

    );


  }
}



