// ignore_for_file: file_names

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
  final List<String> allCourses = [
    'OOP',
    'DSA',
    'MC',
    'Calculus',
    'Discrete',
    'Islamiat'
  ];
  final List<String> _selectedCourses = [];

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

    Map<String, dynamic> studentData = {
      'id': studentId,
      'name': studentName,
      'phone': studentPhone,
      'cgpa': studentCgpa,
      'registration': studentRegistration,
      'courses': _selectedCourses,
      'grades': courseGrades, // Include the grades in the student data
    };

    await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .set(studentData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student account created successfully!'),
      ),
    );
    
  }

  void _createTeacherAccount(String uid) {
    // Implement teacher account creation logic here
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
                    const Text('account'),
                  ],
                ),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ID';
                    }
                    return null;
                  },
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
                const SizedBox(height: 16.0),
                if (_isStudent)
                  const Text(
                    'Courses',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_isStudent)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedCourses.length,
                    itemBuilder: (BuildContext context, int index) {
                      String course = _selectedCourses[index];
                      if (index >= 3 && !_isStudent) {
                        return const SizedBox
                            .shrink(); // Hide the input fields after the third course for admin
                      }
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Text(
                            'Course ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CheckboxListTile(
                            title: Text(course),
                            value: true,
                            onChanged: null,
                            // (bool? value) null,{
                            //   setState(() {
                            //     if (value!) {
                            //       _selectedCourses.add(course);
                            //     } else {
                            //       _selectedCourses.remove(course);
                            //     }
                            //   });
                            // },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Grade'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a grade';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                courseGrades[course] = value;
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

// void main() {
//   runApp(const MaterialApp(
//     home: AccountCreationScreen(),
//   ));
// }
