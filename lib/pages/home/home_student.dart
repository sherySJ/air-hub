
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late String _studentName= '';
  late String _registrationNumber ='';
  late String _email='';
  late double _cgpa=0.0;
  late int _numCourses=0;
  List<Map<String, dynamic>> _courseList = [];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .get();

      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _studentName = studentSnapshot['name'];
        _registrationNumber = studentSnapshot['registration_number'];
        _email = userSnapshot['email'];
        _cgpa = studentSnapshot['cgpa'];
        _numCourses = studentSnapshot['courses'].length;
        _courseList = studentSnapshot['courses'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8.0),
                  Text(
                    _studentName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text('Registration Number: $_registrationNumber'),
              Text('Email: $_email'),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CGPA:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('$_cgpa'),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Courses:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('$_numCourses'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Course List',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _courseList.length,
                  itemBuilder: (context, index) {
                    final course = _courseList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Grade: ${course['grade']}'),
                        // Provide padding for the grade
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Grade: ${course['grade']}'),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
