import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/subjects/components/add_subject_form.dart';
import 'package:student_companion/services/database.dart';
import 'components/subject_card.dart';

class EditSubjects extends StatefulWidget {
  @override
  _EditSubjectsState createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {

  // List containing subjects
  var subjects = [];


  // Function to remove a subject from subjects list
  void removeSubjectFromList(subject) async {

    // ignore: non_constant_identifier_names
    var subjectSet = subjects.toSet();
    subjectSet.remove(subject);
    subjects = subjectSet.toList();
    await DatabaseService(uid: user.uid).updateSubjects(subjects);

  }

  // Function to add an item to subjects list
  void addSubjectToList(String title) async {

    var subjectSet = subjects.toSet();
    subjectSet.add(title);
    subjects = subjectSet.toList();
    await DatabaseService(uid: user.uid).updateSubjects(subjects);
    await DatabaseService(uid: user.uid).createSubjectAttendanceRecord(title);

  }

  // Defining the bottom sheet. I need the context, therefore I define it here
  void _showAddSubjectForm() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding*2),
        child: AddSubjectForm(add: addSubjectToList,),
      );
    });
  }

  // Receiving the map of data sent to this page
  Map data = {};

  User user;


  @override
  Widget build(BuildContext context) {

    // Receiving the uid sent form home page in a map
    data = ModalRoute.of(context).settings.arguments;

    user = data['userObject'];


    return StreamBuilder<List>(
      stream: DatabaseService(uid: user.uid).userSubjects,
      builder: (context, snapshot) {

        subjects = snapshot.data;

        if (snapshot.hasData) {

          return Scaffold(
              backgroundColor: white,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: Text(
                  'Add / Remove Subjects',
                  style: TextStyle(
                    fontFamily: 'MontserratThin',
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                actions: [
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, defaultPadding, 0.0),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => _showAddSubjectForm(),
                  )
                ],
                brightness: Brightness.light,
                backgroundColor: Colors.black,
                elevation: 0.0,
              ),
              body: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return SubjectCardWidget(subject: subjects[index], remove: removeSubjectFromList);
                },
              )

          );


        }

        else {

          return Scaffold(
              backgroundColor: white,
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: Text(
                'Add / Remove Subjects',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: white,
                  ),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, defaultPadding, 0.0),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    ),
                  onPressed: () => _showAddSubjectForm(),
                )
              ],
              brightness: Brightness.light,
              backgroundColor: Colors.black,
              elevation: 0.0,
            ),

          );
        }

      },
    );



  }
}

