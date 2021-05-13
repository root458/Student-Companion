import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/components/menu_option_card.dart';
import 'package:student_companion/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {

    // Determine greeting
    var now = DateTime.now();
    var four59am = DateTime(now.year, now.month, now.day, 4, 59);
    var noon = DateTime(now.year, now.month, now.day, 12, 0);
    var four59pm = DateTime(now.year, now.month, now.day, 16, 59);

    String greeting;
    if (now.isAfter(four59am) && now.isBefore(noon)) {
      greeting = 'Good morning';
    }
    else if (( now.isAtSameMomentAs(noon) || now.isAfter(noon)) && ( now.isAtSameMomentAs(four59pm) || now.isBefore(four59pm) )) {
      greeting = 'Good afternoon';
    }
    else {
      greeting = 'Good evening';
    }

    // Using the data from the Provider
    final user = Provider.of<User>(context);


    var size = MediaQuery.of(context).size;     // total size of screen

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {

          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: lightGrey,
                body: Stack(
                  children: [
                    Container(
                      height: size.height * .45,
                      decoration: BoxDecoration(
                        color: white,
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                alignment: Alignment.topRight,
                                // height: 52,
                                // width: 52,
                                child: FlatButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.logout,
                                      color: white,
                                    ),
                                    label: Text('LOGOUT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                      ),
                                    )),
                              ),
                            ),

                            Text(
                                '${greeting},\n${userData.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 40.0
                                )
                            ),
                            SizedBox(height: 60.0),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                children: <Widget>[
                                  MenuOptionCard(
                                    title: 'Timetable',
                                    pictureSrc: 'assets/images/timetable.png',
                                    press: () {
                                      Navigator.pushNamed(context, '/timetable', arguments: {
                                      'userObject': user
                                      });
                                    },
                                  ),
                                  MenuOptionCard(
                                    title: 'Attendance',
                                    pictureSrc: 'assets/images/attendance.png',
                                    press: () {
                                      Navigator.pushNamed(context, '/attendance',  arguments: {
                                        'userObject': user
                                      });
                                    },
                                  ),
                                  MenuOptionCard(
                                    title: 'Subjects',
                                    pictureSrc: 'assets/images/subjects.png',
                                    press: () {
                                      Navigator.pushNamed(context, '/subjects', arguments: {
                                        'userObject': user
                                      });
                                    },
                                  ),
                                  MenuOptionCard(
                                    title: 'Other',
                                    pictureSrc: 'assets/images/settings.png',
                                    press: () {
                                      Navigator.pushNamed(context, '/superuser', arguments: {
                                        'userObject': user,
                                        'username' : userData.name
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            );

          }

          else {
            return Loading();
          }

        }
    );
  }

}

