import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "profilePage",
            middle: Text("DigiGroups",
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: AllFieldsForm(),
        ));
  }

}

class AllFieldsFormBloc extends FormBloc<String, String> {
  final groupName = TextFieldBloc();

  final groupVisibility = SelectFieldBloc(
    items: ['Public', 'Private'],
  );

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      groupName,
      groupVisibility,
    ]);
  }

  @override
  void onSubmitting() async {
    if(groupName.value.length < 2 || groupName.value.length > 15 ) {
      groupName.addFieldError('Must be between 2 and 15 characters');
    }
    if(groupVisibility.value == null) {
      groupVisibility.addFieldError('Please select an option');
    }
    if(groupName.value.length > 2 && groupName.value.length < 15 && groupVisibility.value != null) {
      //Create group in Firebase DB
      emitSuccess();
    }
  }
}

class AllFieldsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
            ),
            child: Scaffold(
              backgroundColor: primaryColor,
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton.extended(
                    backgroundColor: tertiaryColor,
                    heroTag: "CreateGroupButton",
                    onPressed: formBloc.submit,
                    icon: Icon(Icons.add_rounded),
                    label: Text('Create Group', style: TextStyle(fontFamily: 'Nunito'),),
                  ),
                ],
              ),
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSuccess: (context, state) {
                  Navigator.of(context).pop();
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.groupName,
                          decoration: InputDecoration(
                            labelText: 'Group Name',
                            prefixIcon: Icon(Icons.drive_file_rename_outline, color: tertiaryColor,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: secondaryColor, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            labelStyle: TextStyle(fontFamily: 'Nunito', color: tertiaryColor),
                            errorStyle: TextStyle(fontFamily: 'Nunito'),
                          ),
                          style: TextStyle(fontFamily: 'Nunito', color: Colors.white),
                          cursorColor: Colors.white,
                        ),
                        RadioButtonGroupFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.groupVisibility,
                          decoration: InputDecoration(
                            labelText: 'Group Visibility',
                            prefixIcon: SizedBox(),
                            labelStyle: TextStyle(fontFamily: 'Nunito'),
                            errorStyle: TextStyle(fontFamily: 'Nunito'),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                              BorderSide(color: secondaryColor, width: 1.0),
                            ),
                          ),
                          itemBuilder: (context, item) => item,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AllFieldsForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}