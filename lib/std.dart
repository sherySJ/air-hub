import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSearchScreen extends StatelessWidget {
  final String studentId;
  final String teacherId;

  const StudentSearchScreen({super.key, required this.studentId, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teacher')
          .doc(teacherId)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
              teacherSnapshot) {
        if (teacherSnapshot.hasError) {
          return Text('Error: ${teacherSnapshot.error}');
        }

        if (teacherSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final teacherData = teacherSnapshot.data?.data();
        final teacherClass = teacherData?['courses'][0]['class'];

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('students').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  studentSnapshot) {
            if (studentSnapshot.hasError) {
              return Text('Error: ${studentSnapshot.error}');
            }

            if (studentSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final students = studentSnapshot.data?.docs ?? [];

            final filteredStudents = students
                .where((student) =>
                    student.data()['course'][0]['class'] == teacherClass)
                .toList();

            return _buildSearchResult(context, filteredStudents);
          },
        );
      },
    );
  }

  Widget _buildSearchResult(BuildContext context,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> students) {
    final student = students.firstWhere(
      (student) => student.id == studentId,
    );

    // ignore: unnecessary_null_comparison
    if (student != null) {
      // Student found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Student Found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Student not found or class mismatch
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Student Not Found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Container(); // Return an empty container if no dialog is needed
  }
}

void main() {
  const studentId =
      '210893'; // Replace with the actual student ID you want to search for
  const teacherId =
      'zSeWTJJUfYT3Dhslzv233oyMqAy2'; // Replace with the actual teacher ID
  const searchScreen =
      StudentSearchScreen(studentId: studentId, teacherId: teacherId);

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Student Search'),
      ),
      body: searchScreen,
    ),
  ));
}
