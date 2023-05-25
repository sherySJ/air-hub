// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_import, non_constant_identifier_names

import 'dart:developer';

import 'package:air_hub/manage_teacher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  late User? _currentUser;
  late CollectionReference _studentsCollection;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocumentStream;
  String _teacherName = '';
  String _facultyId = '';
  String _phoneNo = '';
  String _email = '';
  // final int _numCoursesTaught = 0;
  List<dynamic>? TeacherCourseList = [];

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;

    _studentsCollection = FirebaseFirestore.instance.collection('teachers');
    _userDocumentStream = _currentUser != null
        ? _studentsCollection.doc(_currentUser!.email).snapshots()
            as Stream<DocumentSnapshot<Map<String, dynamic>>>
        : Stream<DocumentSnapshot<Map<String, dynamic>>>.empty();
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = FirebaseAuth.instance.currentUser;

    // log(_currentUser!.email.toString());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    // log(userData.toString());
                    _teacherName = userData?['name'] ?? '';
                  }
                  return Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(Icons.person),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(
                          text: _teacherName,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    _facultyId = userData?['id'] ?? '';
                  }
                  return Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Faculty ID: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                        TextSpan(
                          text: _facultyId,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8.0),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    _phoneNo = userData?['phone'] ?? '';
                  }
                  return Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Phone# ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                        TextSpan(
                          text: _phoneNo.toString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    _email = userData?['email'] ?? '';
                  }
                  return Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Email: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                        TextSpan(
                          text: _email,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF8F8F8F),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              Container(
                height: 260,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEBDC2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Courses Taught',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 170.0,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: _userDocumentStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                !snapshot.data!.exists) {
                              return Center(
                                  child: Text('No courses found for the user'));
                            } else {
                              List<Map<String, dynamic>> _courseList = [];
                              if (snapshot.hasData && snapshot.data!.exists) {
                                var userData = snapshot.data!.data();
                                _courseList = List<Map<String, dynamic>>.from(
                                    userData?['courses'] ?? []);
                              }

                              Map<String, dynamic>? userData =
                                  snapshot.data!.data();
                              List<dynamic>? courses =
                                  userData?['courses']; //list of courses
                              TeacherCourseList = courses;

                              if (courses == null || courses.isEmpty) {
                                return Center(
                                    child:
                                        Text('No courses found for the user'));
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _courseList.length,
                                  itemBuilder: (context, index) {
                                    //final subject = 'courses ${index + 1}';
                                    final subject = _courseList[index]['class'];
                                    final section1 =
                                        _courseList[index]['section'];

                                    return ListTile(
                                      title: Text(subject),
                                      subtitle: Text(section1),
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6C4FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Student Record',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageTeacherPage(
                                      FacultyID: _facultyId,
                                      phone: _phoneNo,
                                      email: _email,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/manage_button.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
