import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late String _studentName = '';
  late String _registrationNumber = '';
  late String _email = '';
  late double _cgpa = 0.0;
  late int _numCourses = 0;
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100.0),
              const Icon(
                Icons.person,
                size: 30.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                _studentName,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Reg# $_registrationNumber',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Email: $_email',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'CGPA',
                      content: _cgpa.toStringAsFixed(2),
                      backgroundColor: const Color(0xFFDCEEFE),
                      textColor: const Color.fromARGB(255, 11, 55, 91),
                      alignment: Alignment.topLeft,
                      textStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
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
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                margin: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFBECDFD),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
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
                          Text(
                            'Subjects',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _courseList.length,
                        itemBuilder: (context, index) {
                          final subject = _courseList[index]['subject'];
                          final grade = _courseList[index]['grade'];

                          return ListTile(
                            title: Text(subject),
                            subtitle: Text('Grade: $grade'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

  const InfoCard({super.key, 
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.textColor,
    required this.alignment,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
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
      ),
    );
  }
}
