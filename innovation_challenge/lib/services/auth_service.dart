import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool madeNewAccount = false;

  Stream<String> get onAuthStateChanged => firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await currentUser.user.updateProfile(displayName: name);
    await currentUser.user.reload();

    final databaseReference = FirebaseFirestore.instance;
    await databaseReference.collection("User Data").doc(email).set({
      "Name": name,
      "Diet Plan": "Not Set",
      "Points": 0,
      "Questionnaire": false,
      "Previous Use Date": DateTime.now().subtract(Duration(days: 7)),
      "Previous Use Date for DigiDiet":
          DateTime.now().subtract(Duration(days: 7))
    });

    databaseReference
        .collection("User Data")
        .doc(email)
        .collection("Exercise Logs");

    madeNewAccount = true;
    return currentUser.user.uid;
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    madeNewAccount = false;
    return (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  // Sign Out
  signOut() {
    return firebaseAuth.signOut();
  }
}

class NameValidator {
  static String validate(String value) {
    print("asdfasdfadsf  " + value);
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 10) {
      return "Name must be less than 20 characters long";
    }
    return null;
  }
}

class EmailInputValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    if (!EmailValidator.validate(value)) {
      //RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return "Invalid email address";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }
}
