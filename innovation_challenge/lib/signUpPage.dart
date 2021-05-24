import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:DigiHealth/main.dart';
import 'services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'provider_widget.dart';
import 'package:DigiHealth/appPrefs.dart';

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

  String _email = "", _password = "", _name = "", _error;
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
    if (authFormType == AuthFormType.signUp) {
      if (NameValidator.validate(_name) != null) {
        setState(() {
          _error = NameValidator.validate(_name);
        });
        return false;
      }
    }

    if (EmailInputValidator.validate(_email) != null) {
      setState(() {
        _error = EmailInputValidator.validate(_email);
      });
      return false;
    }

    if (PasswordValidator.validate(_password) != null) {
      setState(() {
        _error = PasswordValidator.validate(_password);
      });
      return false;
    }

    return true;
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          await auth.signInWithEmailAndPassword(_email, _password);
          // Navigator.of(context).pushReplacementNamed('/home');
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(
              builder: (context) => LoadingScreen(),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 500), () {});

          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => HomeController()),
            (Route<dynamic> route) => false,
          );

          Navigator.pushNamed(context, '/home');
        } else {
          await auth.createUserWithEmailAndPassword(_email, _password, _name);
          // Navigator.of(context).pushReplacementNamed('/home');
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute(
              builder: (context) => LoadingScreen(),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 500), () {});

          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => HomeController()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        print("Form Submit Error (signUpPage.dart): $e");
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: primaryColor,
        height: _height,
        width: _width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: _height * 0.025),
              showAlert(),
              SizedBox(height: _height * 0.025),
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
    ));
  }

  Widget showAlert() {
    if (_error != null) {
      print("error opened: $_error");
      return Container(
            color: Colors.amberAccent,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.error_outline),
                ),
                Expanded(
                  child: AutoSizeText(
                    _error,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    },
                  ),
                )
              ],
            ),
          );
    }
    return SizedBox(
      height: 0,
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
      style: TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w200),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    //if we're in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(CupertinoTextField(
        style: TextStyle(
            fontSize: 22,
            color: Colors.black87,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w300),
        onChanged: (String value) => _name = value,
        placeholder: "Display Name (4-10 char)",
        placeholderStyle: TextStyle(color: hintColor),
        cursorColor: Colors.black87,
        keyboardType: TextInputType.text,
        decoration: BoxDecoration(
            color: textColor, borderRadius: BorderRadius.circular(9)),
      ));
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(CupertinoTextField(
      style: TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w300),
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
        style: TextStyle(
            fontSize: 22,
            color: Colors.black87,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w300),
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
            style: TextStyle(
                fontSize: 28,
                color: primaryColor,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w300),
          ),
          onPressed: submit,
        ),
      ),
      SizedBox(height: _height * 0.025),
      CupertinoButton(
        child: Text(
          _switchButton,
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w300),
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
                style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
