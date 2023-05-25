// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  Future<void> emailLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // final snackBar = SuccessSnackbar("Logged in!", Colors.greenAccent);
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(snackBar);
    } on FirebaseAuthException {
      // handle error
      // final snackBar = FailureSnackbar(e.toString());
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(snackBar);
    }
  }

  /// Anonymous Firebase login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException {
      // handle error
    }
  }

  Future<void> registerUser(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
