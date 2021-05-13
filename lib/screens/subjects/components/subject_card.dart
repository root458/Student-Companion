import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';

class SubjectCardWidget extends StatelessWidget {

  final String subject;
  final Function remove;

  SubjectCardWidget({this.subject, this.remove});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shadowColor: lightGrey,
      elevation: 7.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              subject,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: white,
              ),
            ),
            SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.delete,
                      color: white,
                    ),
                    onPressed: () {
                      remove(subject);
                    }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}