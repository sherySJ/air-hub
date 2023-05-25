// ignore_for_file: non_constant_identifier_names, avoid_print, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ManageTeacherPage extends StatefulWidget {
  List<dynamic>? TeacherCoursesList;

  String FacultyID;
  String phone;
  String email;

  ManageTeacherPage(
      {super.key,
      required this.FacultyID,
      required this.phone,
      required this.email});

  @override
  State<ManageTeacherPage> createState() => _ManageTeacherPageState();
}

class _ManageTeacherPageState extends State<ManageTeacherPage> {
  String _teacherName = '';

  String _rollNo = '';
  late List<Subject> _subjectsList = [];

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

  Future<void> UpdateStudentGrades() async {
    for (Subject sub in _subjectsList) {
      // I need to find the document with sub.
      final ref =
          FirebaseFirestore.instance.collection("courses").doc(sub.docID);
      var data = {
        'assignments': [sub.assignment1, sub.assignment2, sub.assignment3],
        'quizzes': [
          sub.quiz1,
          sub.quiz2,
          sub.quiz3,
        ],
        'exams': [sub.midExam, sub.finalExam],
        'project': sub.project,
      };
      return ref.set(data, SetOptions(merge: true));
    }
  }

  late User? _currentUser;
  late CollectionReference _studentsCollection;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocumentStream;
  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _studentsCollection = FirebaseFirestore.instance.collection('teachers');
    _userDocumentStream = _currentUser != null
        ? _studentsCollection.doc(_currentUser!.uid).snapshots()
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
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDocumentStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data();
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
                    widget.FacultyID = userData?['id'] ?? '';
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
                          text: widget.FacultyID,
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
                    widget.phone = userData?['phone'] ?? '';
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
                          text: widget.phone.toString(),
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
                    widget.email = userData?['email'] ?? '';
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
                          text: widget.email,
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
              const SizedBox(height: 16.0),
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      log(value);
                      setState(() {
                        _rollNo = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      filled: true,
                      fillColor: const Color.fromRGBO(
                          244, 244, 244, 1), // Light gray color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      final studentData =
                          await fetchCourses(_rollNo, widget.FacultyID);
                      log(_rollNo);
                      log(widget.FacultyID);
                      log(studentData.toString());

                      List<Subject> subjectsList = [];
                      try {
                        for (final course in studentData) {
                          log(course.runtimeType.toString());
                          final String subjectName =
                              course['subjectName'] ?? 'MC';
                          final String quiz1 = course['quizzes'][0] ?? '0';
                          final String quiz2 = course['quizzes'][1] ?? '0';
                          final String quiz3 = course['quizzes'][2] ?? '0';
                          final String assignment1 =
                              course['assignments'][0] ?? '0';
                          final String assignment2 =
                              course['assignments'][1] ?? '0';
                          final String assignment3 =
                              course['assignments'][2] ?? '0';
                          final String midExam = course['exams'][0] ?? '0';
                          final String finalExam = course['exams'][1] ?? '0';
                          final String project = course['project'] ?? '0';
                          final String facultyID = course['facultyID'] ?? '';
                          final String studentID =
                              course['stdRegistration'] ?? '';
                          final String docID = course['docid'] ?? '';
                          final Subject subject = Subject(
                            name: subjectName,
                            quiz1: quiz1,
                            quiz2: quiz2,
                            quiz3: quiz3,
                            assignment1: assignment1,
                            assignment2: assignment2,
                            assignment3: assignment3,
                            midExam: midExam,
                            finalExam: finalExam,
                            project: project,
                            facultyID: facultyID,
                            studentID: studentID,
                            docID: docID,
                          );

                          subjectsList.add(subject);
                        }
                      } catch (e) {
                        log(e.toString());
                      }

                      setState(
                        () {
                          _subjectsList = subjectsList;
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor:
                          const Color.fromRGBO(66, 133, 244, 1), // Blue color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16.0),
                  Container(
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 215, 144, 144),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Result',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // Perform the update record action here
                                  // This is just a placeholder
                                  await UpdateStudentGrades();
                                  // print('Record updated!');
                                },
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: const Color.fromRGBO(
                                      66, 133, 244, 1), // Blue color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: _subjectsList.length,
                              itemBuilder: (context, index) {
                                final subject = _subjectsList[index];

                                final quiz1Controller = TextEditingController(
                                    text: subject.quiz1.toString());
                                final quiz2Controller = TextEditingController(
                                    text: subject.quiz2.toString());
                                final quiz3Controller = TextEditingController(
                                    text: subject.quiz3.toString());
                                final assignment1Controller =
                                    TextEditingController(
                                        text: subject.assignment1.toString());
                                final assignment2Controller =
                                    TextEditingController(
                                        text: subject.assignment2.toString());
                                final assignment3Controller =
                                    TextEditingController(
                                        text: subject.assignment3.toString());
                                final midExamController = TextEditingController(
                                    text: subject.midExam.toString());
                                final finalExamController =
                                    TextEditingController(
                                        text: subject.finalExam.toString());
                                final projectController = TextEditingController(
                                    text: subject.project.toString());

                                return ExpansionTile(
                                  title: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          // color: Colors.blue,
                                        ),
                                        // Replace with desired arrow icon
                                        const SizedBox(width: 8.0),
                                        Text(
                                          subject.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            // color: Colors
                                            //     .orange,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Quizzes',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: quiz1Controller,
                                                onChanged: (value) {
                                                  // Update the subject's quiz 1 marks
                                                  subject.quiz1 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Q1',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller: quiz2Controller,
                                                onChanged: (value) {
                                                  // Update the subject's quiz 2 marks
                                                  subject.quiz2 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Q2',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller: quiz3Controller,
                                                onChanged: (value) {
                                                  // Update the subject's quiz 3 marks
                                                  subject.quiz3 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Q3',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          'Assignments',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    assignment1Controller,
                                                onChanged: (value) {
                                                  // Update the subject's assignment 1 marks
                                                  subject.assignment1 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'A1',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    assignment2Controller,
                                                onChanged: (value) {
                                                  // Update the subject's assignment 2 marks
                                                  subject.assignment2 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'A2',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    assignment3Controller,
                                                onChanged: (value) {
                                                  // Update the subject's assignment 3 marks
                                                  subject.assignment3 = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'A3',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          'Exams',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: midExamController,
                                                onChanged: (value) {
                                                  // Update the subject's mid exam marks
                                                  subject.midExam = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Mid Exam',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller: finalExamController,
                                                onChanged: (value) {
                                                  // Update the subject's final exam marks
                                                  subject.finalExam = value;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Final Exam',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        TextFormField(
                                          controller: projectController,
                                          onChanged: (value) {
                                            // Update the subject's project marks
                                            subject.project = value;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Project',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
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
