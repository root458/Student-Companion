import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';


class MenuOptionCard extends StatelessWidget {

  final String title;
  final String pictureSrc;
  final Function press;
  const MenuOptionCard({Key key, this.title, this.pictureSrc, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 17),
                blurRadius: 17,
                spreadRadius: -23,
                color: Colors.blueGrey,
              ),
            ]
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    child: Image.asset(pictureSrc),
                  ),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}