import 'package:flutter/material.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/timetable/components/activity_card_widget.dart';
import 'package:student_companion/services/database.dart';


class EditActivities extends StatefulWidget {
  @override
  _EditActivitiesState createState() => _EditActivitiesState();
}

class _EditActivitiesState extends State<EditActivities> {

  // Function to remove activity from list
  void removeActivity(Map map) async {
    List dayOfWeekActivities = [];
    activitiesList.remove(map);

    for (var i in activitiesList) {
      if (i['day'] == map['day']) {
        var activitiesSet = dayOfWeekActivities.toSet();
        activitiesSet.add(i);
        dayOfWeekActivities = activitiesSet.toList();
      }
    }

    await DatabaseService(uid: user.uid).updateDayActivities(map['day'], dayOfWeekActivities);
    setState(() {

    });
  }

  // List of maps of activities
  List<Map> activitiesList = [];


  Map data = {};

  User user;


  @override
  Widget build(BuildContext context) {

    // Receiving the uid sent form home page in a map
    data = ModalRoute.of(context).settings.arguments;

    user = data['userObject'];
    activitiesList = data['activitiesList'];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remove activities',
          style: TextStyle(
            fontFamily: 'MontserratThin',
            fontWeight: FontWeight.bold,
          ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: ListView.builder(
          itemCount: activitiesList.length,
          itemBuilder: (context, index) {
            return ActivityCardWidget(subject: activitiesList[index],removeActivity: removeActivity,);
          }
      ),
    );
  }
}
