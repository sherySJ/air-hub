// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ManageTeacherPage extends StatefulWidget {
//   const ManageTeacherPage({Key? key}) : super(key: key);

//   @override
//   State<ManageTeacherPage> createState() => _ManageTeacherPageState();
// }

// class _ManageTeacherPageState extends State<ManageTeacherPage> {
//   String _teacherName = '';
//   String _facultyId = '';
//   int _phoneNo = 0;
//   String _email = '';
//   List<Subject> _subjectsList = [];

//   Future<Map<String, dynamic>> fetchStudentData(
//       String registrationNumber) async {
//     // Implement the logic to fetch student data from Firebase using the registration number
//     // For example, you can query the Firebase collection and retrieve the document
//     // based on the registration number or email

//     // Replace the following dummy implementation with your actual code

//     await Future.delayed(const Duration(
//         seconds: 2)); // Simulating a delay for demonstration purposes

//     // Return dummy student data
//     return {
//       'name': 'John Doe',
//       'courses': [
//         {
//           'name': 'Mathematics',
//           'quiz1': 80,
//           'quiz2': 90,
//           'quiz3': 75,
//           'assignment1': 85,
//           'assignment2': 92,
//           'assignment3': 80,
//           'midExam': 85,
//           'finalExam': 90,
//           'project': 85,
//         },
//         {
//           'name': 'Science',
//           'quiz1': 75,
//           'quiz2': 85,
//           'quiz3': 80,
//           'assignment1': 90,
//           'assignment2': 88,
//           'assignment3': 82,
//           'midExam': 87,
//           'finalExam': 92,
//           'project': 88,
//         },
//       ],
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40.0),
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     const WidgetSpan(
//                       child: Icon(Icons.person),
//                       alignment: PlaceholderAlignment.middle,
//                     ),
//                     TextSpan(
//                       text: _teacherName,
//                       style: const TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     const TextSpan(
//                       text: 'Faculty ID: ',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                     TextSpan(
//                       text: _facultyId,
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     const TextSpan(
//                       text: 'Phone#: ',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                     TextSpan(
//                       text: _phoneNo.toString(),
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     const TextSpan(
//                       text: 'Email: ',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                     TextSpan(
//                       text: _email,
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         color: Color(0xFF8F8F8F),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24.0),
//               const Text(
//                 'Subjects',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _subjectsList.length,
//                 itemBuilder: (context, index) {
//                   final subject = _subjectsList[index];
//                   return ListTile(
//                     title: Text(subject.name),
//                     subtitle: Text(
//                         'Average Grade: ${subject.calculateAverageGrade().toStringAsFixed(2)}'),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




