// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_import, non_constant_identifier_names, non_constant_identifier_names, must_be_immutable, duplicate_ignore, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class S extends StatefulWidget {
  String FacultyID;
  String phone;
  String email;

  S(
      {super.key,
      required this.FacultyID,
      required this.phone,
      required this.email});

  @override
  State<S> createState() => _SState();
}

class _SState extends State<S> {
  late User? _currentUser;
  late CollectionReference _studentsCollection;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocumentStream;
  late List<Subject> data = [];

  Future<void> displayStudentGrades() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('student', isEqualTo: _currentUser?.email)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No courses found for the user');
      return;
    }

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final subject = data['subject'];
      final grade = data['grade'];

      print('Subject: $subject, Grade: $grade');
    }
  }

  Future<List> fetchCourses(String stdRegistration, String facultyID) async {
    List<dynamic> data = [];
    try {
      CollectionReference coursesCollection =
          FirebaseFirestore.instance.collection('courses');

      QuerySnapshot querySnapshot = await coursesCollection
          .where('stdRegistration', isEqualTo: stdRegistration)
          .where('facultyID', isEqualTo: facultyID)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Iterate over the query results
        for (var doc in querySnapshot.docs) {
          print('Course Document ID: ${doc.id}');
          print('Course Data: ${doc.data()}');
          dynamic d = doc.data();
          d?['docid'] = doc.id;

          data.add(d);
        }
      } else {
        print('No courses found with the given criteria.');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
    return data;
  }

  

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _studentsCollection = FirebaseFirestore.instance.collection('students');
    _userDocumentStream = _currentUser != null
        ? _studentsCollection.doc(_currentUser!.email).snapshots()
            as Stream<DocumentSnapshot<Map<String, dynamic>>>
        : const Stream<DocumentSnapshot<Map<String, dynamic>>>.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              Row(
                children: [
                  const Icon(Icons.person),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _userDocumentStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      String _studentName = '';
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var userData = snapshot.data!.data();
                        _studentName = userData?['name'] ?? 'A';
                      }
                      return Text(
                        _studentName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reg#: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF8F8F8F),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _userDocumentStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      String _registrationNumber = '';
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var userData = snapshot.data!.data();
                        _registrationNumber = userData?['registration'] ?? '';
                      }
                      return Text(
                        _registrationNumber,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF8F8F8F),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone#: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF8F8F8F),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _userDocumentStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      String _phone = '';
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var userData = snapshot.data!.data();
                        _phone = userData?['phone'] ?? '';
                      }
                      return Text(
                        _phone.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF8F8F8F),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF8F8F8F),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _userDocumentStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      String _email = '';
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var userData = snapshot.data!.data();
                        _email = userData?['email'] ?? '';
                      }
                      return Text(
                        _email,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
                    ){
                  String _cgpa = '';
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    List<dynamic>? courses = userData?['courses'];
                    if (courses != null && courses.isNotEmpty) {
                      double totalGradePoints = 0;
                      double totalCredits = 0;

                      for (var course in courses) {
                        String grade = course['grade'] ?? '';
                        double credits = 1.0; // Assuming all subjects have 1 credit hour

                        // Assign values to grades
                        double gradeValue = 0.0;
                        if (grade == 'A') {
                          gradeValue = 3.5;
                        } else if (grade == 'B') {
                          gradeValue = 3.0;
                        } else if (grade == 'C') {
                          gradeValue = 2.5;
                        }

                        totalGradePoints += gradeValue * credits;
                        totalCredits += credits;
                      }

                      if (totalCredits != 0) {
                        double cgpa = totalGradePoints / totalCredits;
                        _cgpa = cgpa.toStringAsFixed(2);
                      }
                    }
                  }
               return   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: 'CGPA',
                          content: _cgpa, //.toStringAsFixed(2),
                          backgroundColor: const Color(0xFFDCEEFE),
                          textColor: const Color.fromARGB(255, 11, 55, 91),
                          alignment: Alignment.topLeft,
                          textStyle: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: _userDocumentStream,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot,
                        ) {
                          int _numCourses = 0;
                          if (snapshot.hasData && snapshot.data!.exists) {
                            var userData = snapshot.data!.data();
                            List<Map<String, dynamic>> courses =
                                List<Map<String, dynamic>>.from(
                                    userData?['courses'] ?? []);
                            _numCourses = courses.length;
                          }
                          return Expanded(
                            child: InfoCard(
                              title: 'Courses',
                              content: _numCourses.toString(),
                              backgroundColor: const Color(0xFFFEE8DC),
                              textColor: const Color.fromARGB(255, 123, 78, 11),
                              alignment: Alignment.topLeft,
                              textStyle: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24.0),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  List<Map<String, dynamic>> _courseList = [];
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
                    _courseList = List<Map<String, dynamic>>.from(
                        userData?['courses'] ?? []);
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFBECDFD),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Course List',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200.0,
                          child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: _userDocumentStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return const Center(
                                    child:
                                        Text('No courses found for the user'));
                              } else {
                                Map<String, dynamic>? userData =
                                    snapshot.data!.data();
                                List<dynamic>? courses = userData?['courses'];
                                if (courses == null || courses.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No courses found for the user'));
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: _courseList.length,
                                    itemBuilder: (context, index) {
                                      final subject =
                                          _courseList[index]['subject'];
                                      final grade = _courseList[index]['grade'];

                                      return ListTile(
                                        title: Text(subject),
                                        // subtitle: Text('Alotted'),
                                        subtitle: Text('Grade: $grade'),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor;
  final Color textColor;
  final Alignment alignment;
  final TextStyle textStyle;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.textColor,
    required this.alignment,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        height: 155,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Align(
                alignment: alignment,
                child: Text(
                  content,
                  style: textStyle,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class Subject {
  String name;
  String quiz1;
  String quiz2;
  String quiz3;
  String assignment1;
  String assignment2;
  String assignment3;
  String midExam;
  String finalExam;
  String project;
  String facultyID;
  String studentID;
  String docID;

  Subject({
    required this.name,
    required this.quiz1,
    required this.quiz2,
    required this.quiz3,
    required this.assignment1,
    required this.assignment2,
    required this.assignment3,
    required this.midExam,
    required this.finalExam,
    required this.project,
    required this.facultyID,
    required this.studentID,
    required this.docID,
  });
}