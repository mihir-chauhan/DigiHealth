import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'provider_widget.dart';

final primaryColor = const Color(0xFF75A2EA);
var secondaryColor = const Color(0xFFFFFFFF);
var hintColor = const Color(0xFF808080);

enum AuthFormType { signIn, signUp }

class SignUpPage extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpPage({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpPageState createState() =>
      _SignUpPageState(authFormType: this.authFormType);
}

class _SignUpPageState extends State<SignUpPage> {
  AuthFormType authFormType;

  _SignUpPageState({this.authFormType});

  String _email, _password, _name;
  final formKey = GlobalKey<FormState>();

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  void submit() async {
    final form = formKey.currentState;
    form.save();

    try {
      final auth = Provider.of(context).auth;
      if(authFormType == AuthFormType.signIn) {
        String uid = await auth.signInWithEmailAndPassword(_email, _password);
        print("Signed In with ID $uid");
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        String uid = await auth.createUserWithEmailAndPassword(_email, _password, _name);
        print("Signed Up with New ID $uid");
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      print("Form Submit Error (signUpPage.dart): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      child: Container(
        color: primaryColor,
        height: _height,
        width: _width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: _height * 0.05),
              buildHeaderText(),
              SizedBox(height: _height * 0.05),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "Create New Account";
    } else {
      _headerText = "Sign In";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 35, color: Colors.white),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    //if we're in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(CupertinoTextField(
        style: TextStyle(fontSize: 22, color: Colors.black87),
        onChanged: (String value) => _name = value,
        placeholder: "Name",
        placeholderStyle: TextStyle(color: hintColor),
        cursorColor: Colors.black87,
        keyboardType: TextInputType.name,
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(9)),
      ));
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(CupertinoTextField(
      style: TextStyle(fontSize: 22, color: Colors.black87),
      onChanged: (String value) => _email = value,
      placeholder: "Email",
      placeholderStyle: TextStyle(color: hintColor),
      cursorColor: Colors.black87,
      keyboardType: TextInputType.emailAddress,
      decoration: BoxDecoration(
          color: secondaryColor, borderRadius: BorderRadius.circular(9)),
    ));
    textFields.add(SizedBox(height: 20));
    textFields.add(CupertinoTextField(
        style: TextStyle(fontSize: 22, color: Colors.black87),
        onChanged: (value) => _password = value,
        cursorColor: Colors.black87,
        placeholder: "Password",
        placeholderStyle: TextStyle(color: hintColor),
        obscureText: true,
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(9))));
    textFields.add(SizedBox(height: 20));
    return textFields;
  }

  List<Widget> buildButtons() {
    String _switchButton, _newFormState, _submitButtonText;

    if (authFormType == AuthFormType.signIn) {
      _switchButton = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
    } else {
      _switchButton = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: CupertinoButton(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Text(
            _submitButtonText,
            style: TextStyle(
                color: primaryColor, fontSize: 28, fontWeight: FontWeight.w300),
          ),
          onPressed: submit,
        ),
      ),
      CupertinoButton(
        child: Text(
          _switchButton,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }
}
