// ignore_for_file: file_names, unused_import, unused_field, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:math';
import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlotCourseScreen extends StatefulWidget {
  const AlotCourseScreen({Key? key}) : super(key: key);
  @override
  _AlotCourseScreenState createState() => _AlotCourseScreenState();
}

class _AlotCourseScreenState extends State<AlotCourseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _facultyID = TextEditingController();
  // final TextEditingController _subject = TextEditingController();
  bool isChecked = false;
  int idx = -1;
  String subjectName = '';
  final Map<String, String> courseGrades = {}; // Map to store course grades
  List<dynamic> allCourses = [
    {'subject': 'Object Oriented Programming', 'isSelected': false},
    {'subject': 'Data Structures & Algorithm', 'isSelected': false},
    {'subject': 'Design Analysis of Algorithms', 'isSelected': false},
    {'subject': 'Full Stack Web Development', 'isSelected': false},
    {'subject': 'Mobile Computing', 'isSelected': false},
    {'subject': 'Linear Algebra', 'isSelected': false},
  ];
  final List<dynamic> _selectedCourses = [];
  String createUID() {
    // Generate a random UID using the current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    final uid = '$timestamp$random';

    return uid;
  }

  Future<void> _alotCourses() async {
    // Implement teacher account creation logic here
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> teacherData = {
        'facultyID': _facultyID.text,
        'stdRegistration': _idController.text,
        'subjectName': subjectName,
        'exams': ["-1", "-1"],
        'quizzes': ["-1", "-1", "-1"],
        'assignments': ["-1", "-1", "-1"],
        'project': "-1",
      };

      await FirebaseFirestore.instance
          .collection('courses')
          .doc(createUID())
          .set(teacherData)
          .onError((error, stackTrace) => d.log(error.toString()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alloted succesfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Creation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _facultyID,
                  decoration: const InputDecoration(labelText: 'Faculty ID'),
                  // obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Faculty ID';
                    }
                    return null;
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: allCourses.length,
                  itemBuilder: (BuildContext context, int index) {
                    String course = allCourses[index]['subject'];

                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          'Course ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        CheckboxListTile(
                          title: Text(course),
                          value: allCourses[index]['isSelected'],
                          onChanged: (bool? value) {
                            if (!isChecked) {
                              setState(() {
                                allCourses[index]['isSelected'] = true;
                                idx = index;
                                isChecked = true;
                                subjectName = allCourses[index]['subject'];
                              });
                            } else {
                              if (idx == index) {
                                setState(() {
                                  isChecked = false;
                                  idx = -1;
                                  allCourses[index]['isSelected'] = false;
                                  subjectName = '';
                                });
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _alotCourses,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
