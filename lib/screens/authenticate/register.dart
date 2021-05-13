import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:student_companion/constants.dart';
import 'package:student_companion/services/auth.dart';


class Register extends StatefulWidget {

  // Accepting the toggle view function
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Instance of AuthService which accesses methods to
  // register and sign in with email and pass: used in an on pressed event
  final AuthService _auth = AuthService();
  // Form key for input validation
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // Form fields, taking note of their states
  String name = '';
  String email = '';
  String password = '';

  // Upon an attempt to register
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: white,
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Text('Do',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 70.0, 0.0, 0.0),
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(265.0, 70.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: lightBlue,
                        )
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'YOUR NAME',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: darkGrey
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: lightBlue)
                            )
                        ),
                        validator: (val) => val.trim().length < 1 ? 'Enter a name consisting of 1+ characters' : null,
                        onChanged: (val) {

                          setState(() {
                            name = val.trim();
                          });

                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: darkGrey
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: lightBlue)
                            )
                        ),
                        validator: (val) => EmailValidator.validate(val.trim()) ? null : 'Enter a valid email address',
                        onChanged: (val) {

                          setState(() {
                            email = val.trim();
                          });

                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: darkGrey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: lightBlue)
                            )
                        ),
                        validator: (val) => val.trim().length < 6 ? 'Password less than 6 characters long' : null,
                        onChanged: (val) {

                          setState(() {
                            password = val.trim();
                          });

                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 45.0),
                      Container(
                        height: 40.0,
                        child: GestureDetector(
                          onTap: () async {

                            if (_formkey.currentState.validate()) {

                              setState(() {
                                loading = true;
                              });

                              // AuthService method to register user when validation is successful
                              dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);

                              if (result == null) {
                                setState(() {
                                  loading  = false;
                                  error = 'Credentials may have been used before. Try again';
                                });
                              }

                              // Else, the Wrapper gets a new user and shows the Home Page

                            }

                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                )
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: lightBlue,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(fontFamily: 'Montserrat',
                  color: Colors.red,
                  ),
                ),
                SizedBox(width: 5.0),

              ],
            )
          ],
        ));
  }
}

