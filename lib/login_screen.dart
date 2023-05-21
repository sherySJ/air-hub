// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> emailLogin(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? uid = userCredential.user?.uid;
      return uid;
    } catch (error) {
      print('Login error: $error');
      return null;
    }
  }
}

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  String _email = '';
  String _password = '';
  Future<void> _login() async {
    try {
      // Perform login and get the user's UID
      String? uid = await AuthService().emailLogin(_email, _password);

      // Check if the user's UID has a 'studID' field in the collection
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid) // Use the UID of the authenticated user
          .get();

      if (snapshot.exists) {
        Navigator.pushNamed(context, '/student');
      } else {
        Navigator.pushNamed(context, '/teacher');
      }
    } catch (error) {
      print('Login error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AirHub',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(66, 133, 244, 1), // Blue color
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor:
                    const Color.fromRGBO(244, 244, 244, 1), // Light gray color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor:
                    const Color.fromRGBO(244, 244, 244, 1), // Light gray color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromRGBO(66, 133, 244, 1), // Blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 22.0),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
