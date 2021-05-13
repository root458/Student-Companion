import 'package:flutter/material.dart';
import 'package:student_companion/screens/authenticate/register.dart';
import 'package:student_companion/screens/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  // Handling the toggling of the Sign In and Register forms
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      // Passing the function down so that it can be accessed to toggle View
      return SignIn(toggleView: toggleView);
    }
    else {
      // Passing the function down so that it can be accessed to toggle View
      return Register(toggleView: toggleView);
    }
  }
}



