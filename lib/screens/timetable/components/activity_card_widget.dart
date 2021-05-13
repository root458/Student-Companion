import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';


class ActivityCardWidget extends StatefulWidget {

  Map subject;

  Function removeActivity;

  ActivityCardWidget({this.subject, this.removeActivity});

  @override
  _ActivityCardWidgetState createState() => _ActivityCardWidgetState();
}

class _ActivityCardWidgetState extends State<ActivityCardWidget> {

  String representNum(int num) {
    if (num < 10) {
      return '0'+num.toString();
    }
    else{
      return num.toString();
    }
  }






  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      shadowColor: lightGrey,
      elevation: 7.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.subject['title'],
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: white,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Day: ${widget.subject['day']}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: white,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Start Time: ${representNum(widget.subject['startTime'][0])}:${representNum(widget.subject['startTime'][1])}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: white,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              'Stop Time: ${representNum(widget.subject['stopTime'][0])}:${representNum(widget.subject['stopTime'][1])}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: white,
              ),
            ),
            SizedBox(height: 5.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.delete,
                      color: white,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      await widget.removeActivity(widget.subject);
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
