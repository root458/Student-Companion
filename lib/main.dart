import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:student_companion/screens/attendance/attendance.dart';
import 'package:student_companion/screens/subjects/subjects.dart';
import 'package:student_companion/screens/superuser/super_user.dart';
import 'package:student_companion/screens/timetable/components/edit_activities.dart';
import 'package:student_companion/screens/timetable/timetable.dart';
import 'package:student_companion/screens/wrapper.dart';
import 'package:student_companion/services/auth.dart';
import 'constants.dart';
import 'models/user.dart';
import 'package:flutter/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {

  // Set up screen orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('student');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
    (int id, String title, String body, String payload) async {}
  );

  var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload' + payload);
        }
      });

  // RUN APP IS DEFINED HERE
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: white,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Returns Wrapper which is the root of the application
  // StreamProvider listens and transmits the data to the children widgets
  // The value property uses the getter specified for the stream

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/' : (context) => Wrapper(),
          '/subjects' : (context) => EditSubjects(),
          '/timetable' : (context) => Timetable(),
          '/attendance' : (context) => Attendance(),
          '/superuser' : (context) => SuperUserPage(),
          '/editactivities' : (context) => EditActivities()
        },
      ),
    );
  }
}








