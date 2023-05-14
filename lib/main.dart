import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:air_hub/pages/login/login_screen.dart';
import 'package:air_hub/pages/login/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AirHub",
      initialRoute: '/login_screen_flutter', // Initial route
      routes: {
        '/login_screen_flutter': (context) =>  const LoginPage(),
         '/student_screen': (context) => const StudentPage(),
      },
    );
  }
}
 