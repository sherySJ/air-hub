// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  Future<void> _login() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choose User Type'),
        content: const Text('Do you want to go to the Student or Teacher home page?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/student');
            },
            child: const Text('Student'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/teacher');
            },
            child: const Text('Teacher'),
          ),
        ],
      );
    },
  );
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
