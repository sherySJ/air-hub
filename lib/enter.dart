// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({Key? key}) : super(key: key);
  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
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

  bool _isStudent = true;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCourses.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a maximum of 3 courses.'),
          ),
        );
      } else if (courseGrades.length < _selectedCourses.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter grades for all selected courses.'),
          ),
        );
      } else {
        _createAccount();
      }
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _createAccount() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(userCredential.toString());
      String uid = userCredential.user!.uid;

      if (_isStudent) {
        _createStudentAccount(uid);
      } else {
        _createTeacherAccount(uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create account.'),
        ),
      );
    }
  }

  void _createStudentAccount(String uid) async {
    String studentId = _idController.text;
    String studentName = _nameController.text;
    String studentPhone = _phoneController.text;
    String studentCgpa = _cgpaController.text;
    String studentRegistration = _registrationController.text;

    // _selectedCourses
    for (var course in allCourses) {
      if (course['isSelected']) {
        _selectedCourses.add({'subject': course['subject'], 'grade': ''});
      }
    }
    log(_selectedCourses.toString());
    Map<String, dynamic> studentData = {
      'id': studentId,
      'name': studentName,
      'phone': studentPhone,
      'cgpa': studentCgpa,
      'registration': studentRegistration,
      'courses': _selectedCourses,
      // 'grades': courseGrades, // Include the grades in the student data
      'email': _emailController.text,
    };

    await FirebaseFirestore.instance
        .collection('students')
        .doc(_emailController.text)
        .set(studentData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student account created successfully!'),
      ),
    );
  }

  Future<void> _createTeacherAccount(String uid) async {
    // Implement teacher account creation logic here
    String email = _emailController.text;
    String teacherId = _idController.text;
    String teacherName = _nameController.text;
    String teacherPhone = _phoneController.text;

    for (var course in allCourses) {
      if (course['isSelected']) {
        _selectedCourses.add({'class': course['subject'], 'section': ''});
      }
    }

    Map<String, dynamic> teacherData = {
      'id': teacherId,
      'name': teacherName,
      'phone': teacherPhone,
      'email': email,
      'courses': _selectedCourses,
    };

    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(_emailController.text)
        .set(teacherData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teacher account created successfully!'),
      ),
    );
  }

  void resetFields() {
    // how to empty a text controller's value, hoow to wempty textfield using a controller
    _emailController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _idController.text = '';
    _nameController.text = '';
    _phoneController.text = '';
    _cgpaController.text = '';
    _registrationController.text = '';

    allCourses = allCourses
        .map((e) => {'subject': e['subject'], 'isSelected': false})
        .toList();
    _selectedCourses.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm the password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    const Text('Create a'),
                    const SizedBox(width: 8.0),
                    ToggleButtons(
                      isSelected: [_isStudent, !_isStudent],
                      onPressed: (int index) {
                        setState(() {
                          resetFields();
                          _isStudent = index == 0;
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Student'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Teacher'),
                        ),
                      ],
                    ),
                    const Text('  account '),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/alot");
                      },
                      child: const Text('Course Allotment'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone';
                    }
                    return null;
                  },
                ),
                if (_isStudent)
                  TextFormField(
                    controller: _cgpaController,
                    decoration: const InputDecoration(labelText: 'CGPA'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter CGPA';
                      }
                      double? cgpa = double.tryParse(value);
                      if (cgpa == null || cgpa < 0 || cgpa > 4) {
                        return 'Please enter a valid CGPA';
                      }
                      return null;
                    },
                  ),
                if (_isStudent)
                  TextFormField(
                    controller: _registrationController,
                    decoration:
                        const InputDecoration(labelText: 'Registration'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter registration';
                      }
                      return null;
                    },
                  ),
                if (!_isStudent)
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(labelText: 'Faculty ID'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter ID';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16.0),
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
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
                            setState(() {
                              allCourses[index]['isSelected'] =
                                  !allCourses[index]['isSelected'];
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
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
