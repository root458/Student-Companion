import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/screens/authenticate/authenticate.dart';
import 'package:student_companion/screens/home/home.dart';

// Listens for Authentication changes by the user, and shows either
// the authentication section or the Home screen section

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Return either Home or Authentication widget

    // Using the data from the Provider
    final user = Provider.of<User>(context);

    // Return either Home() or Authenticate()
    if (user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }

  }
}

