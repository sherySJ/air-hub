import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_student.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Define variables to store the email and password
  String _email = '';
  String _password = '';

  // Create an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle the login button pressed
  Future<void> _login() async {
    try {
      // Use the FirebaseAuth instance to sign in with email and password
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Access the user object from the UserCredential
      final User? user = userCredential.user;

      if (user != null) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentPage()),
          );
        });
      }

      // TODo: Handle successful login, e.g., navigate to home screen
    } catch (error) {
      // TODo: Handle login failure, e.g., display error message
      // ignore: avoid_print
      print('Login error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirHub',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'AirHub',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
