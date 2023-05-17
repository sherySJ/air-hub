import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _teacherName = '';
  String _facultyId = '';
  final int _phoneNo = 0;
  String _email = '';
  int _numCoursesTaught = 0;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot teacherSnapshot =
          await _firestore.collection('teachers').doc(user.uid).get();

      final DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        _teacherName = teacherSnapshot['name'];
        _facultyId = teacherSnapshot['faculty_id'];
        _email = userSnapshot['email'];
        _numCoursesTaught = teacherSnapshot['courses_taught'].length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 40.0),
            Row(
              children: [
                const Icon(Icons.person),
                const Text(
                  'Faculty ID: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _teacherName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Faculty ID: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _facultyId,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phone# ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _phoneNo.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEBDC2),
                borderRadius: BorderRadius.circular(10),
              ),
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
                    height: 120.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _numCoursesTaught,
                      itemBuilder: (context, index) {
                        final subject = 'Subject ${index + 1}';

                        return ListTile(
                          title: Text(subject),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 120.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE6C4FD),
                borderRadius: BorderRadius.circular(10),
              ),
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
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Add your logic for managing student records
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
