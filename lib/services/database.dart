import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_companion/models/user.dart';

class DatabaseService {

  // Collection reference for the user
  final String uid;
  CollectionReference userCollection;
  CollectionReference timetableCollection;
  CollectionReference attendanceCollection;
  CollectionReference filledCollection;


  DatabaseService({this.uid}) {
    userCollection = Firestore.instance.collection(this.uid);
    timetableCollection = Firestore.instance.collection(this.uid+'timetable');
    attendanceCollection = Firestore.instance.collection(this.uid+'attendance');
    filledCollection = Firestore.instance.collection(this.uid+'filled');
  }

  ///////////////////////////////////////////////////////////////////////////
  // CREATE USER AND RETRIEVE DETAILS
  // Method to initialize collection for user and create first document
  Future updateUserData(String name, String email) async {
    return await userCollection.document('user_details').setData({
      'name' : name,
      'email' : email
    });
  }

  // Stream to alert of any changes in the user collection
  Stream<QuerySnapshot> get userDetails {
    return userCollection.snapshots();
  }

  // Method to get user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        email: snapshot.data['email'],
        name: snapshot.data['name']
    );
  }

  // Get user details stream
  Stream<UserData> get userData {
    return userCollection.document('user_details').snapshots()
        .map(_userDataFromSnapshot);
  }
  ////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////////////////////////////////////////
  // SUBJECTS methods
  // Method to initialize subjects
  Future updateSubjects(List subjects) async {
    return await userCollection.document('subjects').setData({
      'subjects_list' : subjects,
    });
  }

  // Method to get subjects list from snapshot
  List _userSubjectsFromSnapshot(DocumentSnapshot snapshot) {
    return  snapshot.data['subjects_list'];
  }

  // Get user subjects stream
  Stream<List> get userSubjects {
    return userCollection.document('subjects').snapshots()
            .map(_userSubjectsFromSnapshot);
  }
  ///////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
  // SUBJECT DAYS methods
  // Method to initialize subjects days
  Future initializeSubjectsDays() async {
    return await userCollection.document('subjects_days').setData({
      'SUN' : [],
      'MON' : [],
      'TUE' : [],
      'WED' : [],
      'THU' : [],
      'FRI' : [],
      'SAT' : [],
    });
  }

  // Method to update subjects days
  Future updateSubjectsDays(Map map) async {
    return await userCollection.document('subjects_days').setData({
      'SUN': map['SUN'],
      'MON': map['MON'],
      'TUE': map['TUE'],
      'WED': map['WED'],
      'THU': map['THU'],
      'FRI': map['FRI'],
      'SAT': map['SAT'],
    });
  }

  // subjects on days map from document snapshot
  Map _subjectsOnDaysFromSnapshot(DocumentSnapshot snapshot) {
    return  {
      'SUN': snapshot.data['SUN'],
      'MON': snapshot.data['MON'],
      'TUE': snapshot.data['TUE'],
      'WED': snapshot.data['WED'],
      'THU': snapshot.data['THU'],
      'FRI': snapshot.data['FRI'],
      'SAT': snapshot.data['SAT'],
    };
  }

  // Method to get the subjects on particular days of the week
  Stream<Map> get subjectsOnDays {
    return userCollection.document('subjects_days').snapshots()
        .map(_subjectsOnDaysFromSnapshot);
  }

  ///////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
  // TIMETABLE ACTIVITIES methods
  // Method to initialize timetable activities
  // ignore: non_constant_identifier_names
  Future updateDayActivities(String day, List activities) async {
    return await timetableCollection.document(day).setData({
      day : activities
    });
  }


  // Get user timetable stream
  Stream<QuerySnapshot> get userTimetable {
    return timetableCollection.snapshots();
  }
///////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////
  // ATTENDANCE METHODS

  // Method to Initialize
  Future createSubjectAttendanceRecord(String subject) async {
    return await attendanceCollection.document(subject).setData({
      'held' : 0,
      'attended' : 0,
    });
  }


  // Method to delete if needed
  Future deleteSubjectAttendanceRecord(String subject) async {
    return await attendanceCollection.document(subject).delete();
  }

  // Get user attendance stream
  Stream<QuerySnapshot> get userAttendance {
    return attendanceCollection.snapshots();
  }

  // Method to update number held
  Future updateNumberHeld(String subject, int held) async {
    return await attendanceCollection.document(subject).setData({
      'held' : held,
    }, merge: true);
  }

  // Method to update number attended
  Future updateNumberAttended(String subject, int attended) async {
    return await attendanceCollection.document(subject).setData({
      'attended' : attended,
    }, merge: true);
  }


  // Filled subjects
  Future updateFilled(List filled) async {

    var today = DateTime.now();
    String dateToday = '';
    dateToday += representNum(today.year);
    dateToday += representNum(today.month);
    dateToday += representNum(today.day);

    return await filledCollection.document(dateToday).setData({
      'subjects_list' : filled,
    });
  }

  // Get user subjects stream
  Stream<List> get filledSubjects {

    var today = DateTime.now();
    String dateToday = '';
    dateToday += representNum(today.year);
    dateToday += representNum(today.month);
    dateToday += representNum(today.day);

    return filledCollection.document(dateToday).snapshots()
        .map(_userSubjectsFromSnapshot);
  }

  ////////////////////////////////////////////////////////////////////////
  String representNum(int num) {
    if (num < 10) {
      return '0'+num.toString();
    }
    else{
      return num.toString();
    }
  }

}


