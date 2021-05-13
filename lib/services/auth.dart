import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_companion/models/user.dart';
import 'package:student_companion/services/database.dart';

class AuthService {

  // Create an instance of FirebaseAuth
  // For use with registration and signing in

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to create a user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // User stream to listen to auth changes
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }


  // Register with email and Password Method
  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Create a collection for the user and initialize with some data
      await DatabaseService(uid: user.uid).updateUserData(name, email);
      
      // Initialize Subjects
      await DatabaseService(uid: user.uid).updateSubjects(['Subject One']);

      // Initialize Timetable
      List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

      for (var i in days) {
        await DatabaseService(uid: user.uid).updateDayActivities(i, []);
      }

      // Initialize subjects days
      await DatabaseService(uid: user.uid).initializeSubjectsDays();

      // Initialize subjects filled
      await DatabaseService(uid: user.uid).updateFilled([]);

      return _userFromFirebaseUser(user);
    }
    catch (e) {
      return null;
    }
  }


  // Sign in with email and Password Method
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (e) {
      return null;
    }
  }

  // Sign out Method
  Future signOut() async {

    try {
      return await _auth.signOut();
    }
    catch (e) {
      return null;
    }

  }

}



