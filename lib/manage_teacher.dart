import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ManageTeacherPage extends StatefulWidget {
  const ManageTeacherPage({Key? key}) : super(key: key);

  @override
  State<ManageTeacherPage> createState() => _ManageTeacherPageState();
}

class _ManageTeacherPageState extends State<ManageTeacherPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _teacherName = '';
  final String _facultyId = '';
  final int _phoneNo = 0;
  String _email = '';
  late List<Subject> _subjectsList = [];

  Future<Map<String, dynamic>> fetchStudentData(
      String registrationNumber) async {
    // Implement the logic to fetch student data from Firebase using the registration number
    // For example, you can query the Firebase collection and retrieve the document
    // based on the registration number or email

    // Replace the following dummy implementation with your actual code

    await Future.delayed(const Duration(
        seconds: 2)); // Simulating a delay for demonstration purposes

    // Return dummy student data
    return {
      'name': 'John Doe',
      'courses': [
        {
          'name': 'Mathematics',
          'quiz1': 80,
          'quiz2': 90,
          'quiz3': 75,
          'assignment1': 85,
          'assignment2': 92,
          'assignment3': 80,
          'midExam': 85,
          'finalExam': 90,
          'project': 85,
        },
        {
          'name': 'Science',
          'quiz1': 75,
          'quiz2': 85,
          'quiz3': 80,
          'assignment1': 90,
          'assignment2': 88,
          'assignment3': 82,
          'midExam': 87,
          'finalExam': 92,
          'project': 88,
        },
      ],
    };
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
              Text.rich(
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
              ),
              const SizedBox(height: 8.0),
              Text.rich(
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
              ),
              Text.rich(
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
              ),
              Text.rich(
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
              ),
              const SizedBox(height: 24.0),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _email = value;
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
                      final studentData = await fetchStudentData(_email);
                      final List<Subject> subjectsList = [];

                      if (studentData != null) {
                        final List<Map<String, dynamic>> courses =
                            studentData['courses'];

                        for (final course in courses) {
                          final String subjectName = course['name'];
                          final int quiz1 = course['quiz1'];
                          final int quiz2 = course['quiz2'];
                          final int quiz3 = course['quiz3'];
                          final int assignment1 = course['assignment1'];
                          final int assignment2 = course['assignment2'];
                          final int assignment3 = course['assignment3'];
                          final int midExam = course['midExam'];
                          final int finalExam = course['finalExam'];
                          final int project = course['project'];

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
                          );

                          subjectsList.add(subject);
                        }
                      }

                      setState(() {
                        _subjectsList = subjectsList;
                      });
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
                                onPressed: () {
                                  // Perform the update record action here
                                  // This is just a placeholder
                                  print('Record updated!');
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
                                                  subject.quiz1 =
                                                      int.parse(value);
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
                                                  subject.quiz2 =
                                                      int.parse(value);
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
                                                  subject.quiz3 =
                                                      int.parse(value);
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
                                                  subject.assignment1 =
                                                      int.parse(value);
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
                                                  subject.assignment2 =
                                                      int.parse(value);
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
                                                  subject.assignment3 =
                                                      int.parse(value);
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
                                                  subject.midExam =
                                                      int.parse(value);
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
                                                  subject.finalExam =
                                                      int.parse(value);
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
                                            subject.project = int.parse(value);
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
  int quiz1;
  int quiz2;
  int quiz3;
  int assignment1;
  int assignment2;
  int assignment3;
  int midExam;
  int finalExam;
  int project;

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
  });
}
