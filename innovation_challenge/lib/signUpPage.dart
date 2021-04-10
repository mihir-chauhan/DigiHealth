import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:DigiHealth/main.dart';
import 'services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'provider_widget.dart';
import 'package:DigiHealth/appPrefs.dart';

bool error = false;
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

  bool validate() {
    final form = formKey.currentState;
    form.save();

    if (EmailValidator.validate(_email) == null &&
        PasswordValidator.validate(_password) == null) {
      if (authFormType == AuthFormType.signUp) {
        if (NameValidator.validate(_name) == null) {
          error = false;
          return true;
        }
        error = true;
        return false;
      }
      error = false;
      return true;
    }
    error = true;
    return false;
  }

  void submit() async {
    if (validate() && !error) {
      Navigator.of(context, rootNavigator: true).push(
        new CupertinoPageRoute(
          builder: (context) => LoadingScreen(),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500), () {});

      try {
        final auth = Provider
            .of(context)
            .auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Signed In with ID $uid");
          // Navigator.of(context).pushReplacementNamed('/home');
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => HomeController()),
                (Route<dynamic> route) => false,
          );

          Navigator.pushNamed(context, '/home');
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);
          print("Signed Up with New ID $uid");
          // Navigator.of(context).pushReplacementNamed('/home');
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => HomeController()),
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        print("Form Submit Error (signUpPage.dart): $e");
      }
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
      style: TextStyle(fontSize: 35, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w200),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    //if we're in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(CupertinoTextField(
        style: TextStyle(fontSize: 22, color: Colors.black87, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
        onChanged: (String value) => _name = value,
        placeholder: "Name",
        placeholderStyle: TextStyle(color: hintColor),
        cursorColor: Colors.black87,
        keyboardType: TextInputType.name,
        decoration: BoxDecoration(
            color: textColor, borderRadius: BorderRadius.circular(9)),
      ));
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(CupertinoTextField(
      style: TextStyle(fontSize: 22, color: Colors.black87, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
      onChanged: (String value) => _email = value,
      placeholder: "Email",
      placeholderStyle: TextStyle(color: hintColor),
      cursorColor: Colors.black87,
      keyboardType: TextInputType.emailAddress,
      decoration: BoxDecoration(
          color: textColor, borderRadius: BorderRadius.circular(9)),
    ));
    textFields.add(SizedBox(height: 20));
    textFields.add(CupertinoTextField(
        style: TextStyle(fontSize: 22, color: Colors.black87, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
        onChanged: (value) => _password = value,
        cursorColor: Colors.black87,
        placeholder: "Password",
        placeholderStyle: TextStyle(color: hintColor),
        obscureText: true,
        decoration: BoxDecoration(
            color: textColor, borderRadius: BorderRadius.circular(9))));
    textFields.add(SizedBox(height: 80));
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

    final _height = MediaQuery.of(context).size.height;

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: CupertinoButton(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Text(
            _submitButtonText,
            style: TextStyle(fontSize: 28, color: primaryColor, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
          ),
          onPressed: submit,
        ),
      ),
      SizedBox(height: _height * 0.025),
      CupertinoButton(
        child: Text(
          _switchButton,
          style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: primaryColor,
      child: Align(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitFoldingCube(
                color: textColor,
                size: 100,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Loading",
                style: TextStyle(fontSize: 20, color: textColor, fontFamily: 'Nunito', fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
