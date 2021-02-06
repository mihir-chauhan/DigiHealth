import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool madeNewAccount = false;

  Stream<String> get onAuthStateChanged => firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();

    madeNewAccount = true;

    return currentUser.uid;
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    madeNewAccount = false;
    return (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password))
        .uid;
  }

  // Sign Out
  signOut() {
    return firebaseAuth.signOut();
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value?.isEmpty ?? true) {
      return "Email can't be empty";
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value?.isEmpty ?? true) {
      return "Name can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value?.isEmpty ?? true) {
      return "Password can't be empty";
    }
    return null;
  }
}
