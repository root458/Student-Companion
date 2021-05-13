import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/models/attendance_model.dart';
import 'package:student_companion/models/user.dart';


class AttendanceTile extends StatefulWidget {

  User user;
  AttendanceModel attendance;
  AttendanceTile({this.attendance, this.user});

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {

  returnPercentage(int held, int attended) {
    if (held == 0) {
      return 'N/A';
    }
    else if (attended > held) {
      return 'N/A';
    }
    else {
      return (attended/held * 100).toStringAsPrecision(3) + '%';
    }
  }

  returnPercentIndicated(int held, int attended) {
    if (held == 0) {
      return 0.0;
    }
    else if (attended > held) {
      return 0.0;
    }
    else {
      return attended/held * 1;
    }
  }


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
              widget.attendance.subject,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Held: ${widget.attendance.held}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Attended: ${widget.attendance.attended}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Missed: ${widget.attendance.held - widget.attendance.attended}',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Text(
                  'Percentage: ',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  '${returnPercentage(widget.attendance.held, widget.attendance.attended)}',
                  style: TextStyle(
                    fontFamily: 'MontserratThin',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            LinearPercentIndicator(
              width: 250.0,
              lineHeight: 14.0,
              percent: returnPercentIndicated(widget.attendance.held, widget.attendance.attended),
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
