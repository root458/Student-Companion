import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/main.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/timetable/components/add_activity_form.dart';
import 'package:student_companion/services/database.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {

  List<Map> activitiesList = [];
  Map<dynamic, dynamic> subjectsOnDays = {
    'SUN' : [],
    'MON' : [],
    'TUE' : [],
    'WED' : [],
    'THU' : [],
    'FRI' : [],
    'SAT' : [],
  };

  // await DatabaseService(uid: user.uid).updateSubjectsDays(subjectsOnDays);

  //////////////////////////////////////////////////////////////////////////////

  // Defining the activities on the timetable
  // Method to get activities in a list
  // An appointment is an activity. There's an in-built

  // Scheduling reminders
  int id = 0;
  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  var todayWeekday = DateTime.now().weekday;

  List<Appointment> getAppointments() {
    List<Appointment> activities = [];


    for (var i in activitiesList) {

      final DateTime startTime = DateTime(i['date'][0], i['date'][1], i['date'][2],i['startTime'][0],i['startTime'][1],0);
      final DateTime endTime = DateTime(i['date'][0], i['date'][1], i['date'][2],i['stopTime'][0],i['stopTime'][1],0);

      activities.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: i['title'],
          color: Colors.blue,
          recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=${i['day']};UNTIL=20210801'
      ));

      // Updating the subjects days data
      var daySet = subjectsOnDays['${i['day']}'].toSet();
      daySet.add(i['title']);
      subjectsOnDays['${i['day']}'] = daySet.toList();

      // Schedule reminders here
      
      if (days[todayWeekday] == i['day'] && startTime.isAfter(DateTime.now())) {
        scheduleAlarm(i['title'], startTime, id);
        id++;
      }

    }


    return activities;

  }

  //////////////////////////////////////////////////////////////////////////////

  void addActivityToActivitiesList() {
    //await DatabaseService(uid: user.uid).updateSubjectsDays(subjectsOnDays);
    setState(() {});
  }


  // The bottom sheet to add activities
  void _showAddActivityForm() {

    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding*2),
        child: AddActivityForm(user: user, addActivity: addActivityToActivitiesList, subjectsOnDays: subjectsOnDays,),
      );
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
          'Timetable',
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
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {

              Navigator.pushNamed(context, '/editactivities', arguments: {
                'userObject': user,
                'activitiesList':activitiesList
              });

            },
          ),
          IconButton(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            icon: Icon(
              Icons.replay_circle_filled,
              color: Colors.white,
            ),
            onPressed: () async {
              await DatabaseService(uid: user.uid).updateSubjectsDays(subjectsOnDays);
            },
          ),
          IconButton(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, defaultPadding, 0.0),
              icon: Icon(
                  Icons.add,
                  color: Colors.white,
              ),
              onPressed: () {
                _showAddActivityForm();
              },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: user.uid).userTimetable,
        builder: (context, snapshot) {

          QuerySnapshot timetableDays = snapshot.data;

          if (snapshot.hasData) {

            activitiesList.clear();
            for (var doc in timetableDays.documents) {
                String ID = doc.documentID;
                for (var item in doc.data[ID]) {
                  activitiesList.add(item);
                }
            }

          }


          return SfCalendar(
            allowedViews: [CalendarView.week, CalendarView.day, CalendarView.month],
            showNavigationArrow: true,
            allowViewNavigation: true,
            dataSource: ActivitiesDataSource(getAppointments()),
          );

        },
      ),
    );
  }

  void scheduleAlarm(String subject, DateTime scheduledNotificationDateTime, int id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Reminders for subjects',
      'Reminders for subjects',
      'Channel for Alarm notification',
      importance: Importance.Max,
      icon: 'student',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('student'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(id, subject, 'Reminder: ${subject} begins now',
        scheduledNotificationDateTime, platformChannelSpecifics);
  }


}

// Class to get activities for the timetable
class ActivitiesDataSource extends CalendarDataSource {

  ActivitiesDataSource(List<Appointment> source) {
    // this variable holds a list containing activities to be shown on the timetable
    appointments = source;
  }

}





