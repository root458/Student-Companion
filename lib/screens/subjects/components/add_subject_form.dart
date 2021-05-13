import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';


class AddSubjectForm extends StatefulWidget {

  Function add;
  AddSubjectForm({this.add});

  @override
  _AddSubjectFormState createState() => _AddSubjectFormState();
}

class _AddSubjectFormState extends State<AddSubjectForm> {

  // Form Key to determine validation
  final _formkey = GlobalKey<FormState>();

  // Form value
  String _currentSubject = '';


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Container(
            child: Text('INPUT SUBJECT TITLE',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                )
            ),
          ),
          SizedBox(height: 40.0,),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'SUBJECT TITLE',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: darkGrey,
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightBlue)
                )
            ),
            validator: (val) => val.trim().length < 2 ? 'Enter a title consisting of 2+ characters' : null,
            onChanged: (val) {

              setState(() {
                _currentSubject = val.trim();
              });

            },
          ),
          SizedBox(height: 40.0),
          Container(
            height: 40.0,
            child: GestureDetector(
              onTap: () async {

                if (_formkey.currentState.validate()) {

                  await widget.add(_currentSubject);

                  Navigator.pop(context);
                }

              },
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.blueAccent,
                color: Colors.blue,
                elevation: 7.0,
                child: Center(
                  child: Text(
                    'ADD SUBJECT',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



