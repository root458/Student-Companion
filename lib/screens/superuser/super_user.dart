import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/services/auth.dart';
import 'package:student_companion/services/database.dart';

class SuperUserPage extends StatefulWidget {
  @override
  _SuperUserPageState createState() => _SuperUserPageState();
}

class _SuperUserPageState extends State<SuperUserPage> {

  final AuthService _auth = AuthService();

  // Receiving the map of data sent to this page
  Map data = {};

  User user;
  String name;

  bool subjectsInitialized = false;
  bool timetableInitialized = false;


  @override
  Widget build(BuildContext context) {

    // Receiving the uid sent form home page in a map
    data = ModalRoute.of(context).settings.arguments;

    user = data['userObject'];
    name = data['username'];


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alter your data',
          style: TextStyle(
            fontFamily: 'MontserratThin',
            fontWeight: FontWeight.bold,
          ),
        ),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
          padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Hi, ${name}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 40.0
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              'You can initialize your data here',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
            SizedBox(height: 90.0,),
            ListTile(
              tileColor: subjectsInitialized ? Colors.green : Colors.grey,
              leading: Icon(
                Icons.delete_forever,
                size: 30.0,
                color: Colors.white,
              ),
              title: Text(
                'INITIALIZE SUBJECTS',
                style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white
                ),
              ),
              subtitle: Text(
                subjectsInitialized ? 'Your subjects have been removed' : 'All your subjects will be removed',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white
                ),
              ),
              onTap: () async {

                await DatabaseService(uid: user.uid).updateSubjects([]);
                setState(() {
                  subjectsInitialized = true;
                });

              },
            ),
            SizedBox(height: 10.0,),
            ListTile(
              tileColor: timetableInitialized ? Colors.green : Colors.grey,
              leading: Icon(
                Icons.delete_forever,
                size: 30.0,
                color: Colors.white,
              ),
              title: Text(
                'INITIALIZE TIMETABLE',
                style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white
                ),
              ),
              subtitle: Text(
                timetableInitialized ? 'All your timetable activities have been removed' : 'All your timetable activities will be removed',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white
                ),
              ),
              onTap: () async {

                // Initialize Timetable
                List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

                for (var i in days) {
                  await DatabaseService(uid: user.uid).updateDayActivities(i, []);
                }

                setState(() {
                  timetableInitialized = true;
                });

              },
            ),
            SizedBox(height: 200.0,),
            ListTile(
              tileColor: Colors.redAccent[700],
              leading: Icon(
                Icons.logout,
                size: 30.0,
                color: Colors.white,
              ),
              title: Text(
                  'LOGOUT',
                style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.white
                ),
              ),
              subtitle: Text(
                'You will see the sign in screen',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white
                ),
              ),
              onTap: () async {

                // Alters the state and the Stream returns null, leading to logging out
                await _auth.signOut();
                Navigator.pop(context);
              },
            )

          ],
        ),
      ),
    );
  }
}
