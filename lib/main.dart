// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:air_hub/login_screen.dart';
import 'package:air_hub/home_student.dart';
import 'package:air_hub/home_teacher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'manage_teacher.dart';

Future<void> main() async {
  print(DefaultFirebaseOptions.currentPlatform.toString());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirHub',
      // '/':(context) => Splash(),
      routes: {
        '/': (context) => LoginPage(),
        '/student': (context) => StudentPage(),
        '/teacher': (context) => TeacherPage(),
        '/manager': (context) => ManageTeacherPage(),

      },
    );
  }
}
