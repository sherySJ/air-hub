// ignore_for_file: avoid_print, unused_import, use_build_context_synchronously

import 'dart:developer';

import 'package:air_hub/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      await AuthService().emailLogin(_email, _password);
      if (AuthService().user == null) {
        return;
      }
      // Check if the user's UID has a 'studID' field in the collection

      final DocumentSnapshot studentsnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(AuthService()
              .user
              ?.email) // Use the UID of the authenticated user
          .get();

      if (studentsnapshot.exists) {
        Navigator.pushNamed(context, '/student');
      }
      final DocumentSnapshot teachersnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(AuthService()
              .user
              ?.email) // Use the UID of the authenticated user
          .get();
      if (teachersnapshot.exists) {
        Navigator.pushNamed(context, '/teacher');
      }
    } catch (error) {
      print('Login error: $error');
    }
  }

  Future<void> adminLogin() async {
    try {
      // Perform login and get the user's UID
      await AuthService().emailLogin(_email, _password);
      if (AuthService().user == null) {
        return;
      }

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(AuthService()
              .user
              ?.email) // Use the UID of the authenticated user
          .get();

      if (snapshot.exists) {
        Navigator.pushNamed(context, '/admin');
      } else {
        log('Admin');
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
          // vertical: 130,
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
              ),
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
                  fillColor: const Color.fromRGBO(
                      244, 244, 244, 1), // Light gray color
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
                  fillColor: const Color.fromRGBO(
                      244, 244, 244, 1), // Light gray color
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_outlined,
                        color: Color.fromARGB(171, 0, 0, 1),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: adminLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 255, 255, 255), // Blue color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Color.fromARGB(171, 0, 0, 1),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: Color.fromARGB(171, 0, 0, 1),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
