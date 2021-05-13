import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';


class SelectDay extends StatefulWidget {
  @override
  _SelectDayState createState() => _SelectDayState();
}

class _SelectDayState extends State<SelectDay> {

  // List to define the days of the week
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];

  // BY DEFAULT SUNDAY IS SELECTED
  int selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: SizedBox(
        height: 25.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) => buildDay(index)
        ),
      ),
    );
  }

  Widget buildDay(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              days[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedDay ==index ? textColor : textLightColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: defaultPadding / 4),
              height: 2,
              width: 30,
              color: selectedDay == index ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

/*
* Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'Timetable',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 40.0
              ),
            ),
          ),
          // Days of the week widget here
          SelectDay(),
        ],
      ),
*
* */