import 'package:DigiHealth/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

List<CardItem> groupImageChoices = [
  ImageCarditem(
      image: Image.network(
          "https://firebasestorage.googleapis.com/v0/b/innov8rz-innovation-challenge.appspot.com/o/DigiGroup_1.png?alt=media&token=d7dbb7ef-ac75-4eeb-a732-cf3bf9c207e7"))
];
List<String> groupImageChoiceLinks = [];
int selectedImageIndex = 0;
User user;
BuildContext buildContext;

class _CreateGroupPageState extends State<CreateGroupPage> {
  bool hasUpdatedGroupImageChoices = false;
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    user = Provider.of(context).auth.firebaseAuth.currentUser;
    if (!hasUpdatedGroupImageChoices) {
      hasUpdatedGroupImageChoices = true;
      groupImageChoices.clear();
      FirebaseFirestore.instance
          .collection("Global Data")
          .doc("DigiGroup Images")
          .get()
          .then((DocumentSnapshot doc) {
        Map<String, dynamic> map = doc.data();
        map.forEach((key, value) {
          setState(() {
            groupImageChoiceLinks.add(value.toString());
            groupImageChoices.add(ImageCarditem(image: Image.network(value)));
          });
        });
      });
    }
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

  final groupType = SelectFieldBloc(
    items: ['Physical Health', 'Mental Health'],
  );

  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [groupName, groupVisibility, groupType]);
  }

  @override
  void onSubmitting() async {
    bool error = false;
    if (groupName.value.length < 2 || groupName.value.length > 15) {
      groupName.addFieldError('Must be between 2 and 15 characters');
      error = true;
    }
    if (groupVisibility.value == null) {
      groupVisibility.addFieldError('Please select an option');
      error = true;
    }
    if (groupType.value == null) {
      groupType.addFieldError('Please select an option');
      error = true;
    }
    if (!error) {
      print("CREATING GROUP");
      //Create group in Firebase DB
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .doc(groupName.value)
          .set({
        "visibility": groupVisibility.value.toString(),
        "image": groupImageChoiceLinks.elementAt(selectedImageIndex),
        "type": groupType.value.toString(),
      }, SetOptions(merge: true));

      String text = groupVisibility.value == "Public"
          ? " to all users."
          : " from other users.";
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .doc(groupName.value)
          .collection("Chat")
          .add({
        "created": DateTime.now(),
        "message":
            "Welcome to the '${groupName.value}' group! Feel free to chat and encourage other group members. Your group is ${groupVisibility.value.toString().toLowerCase()}" +
                text +
                " Have fun! - DigiHealth Team",
        "sentBy": "DigiHealth",
      });
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .doc(groupName.value)
          .collection("Members")
          .doc(user.email)
          .set({
        "Name": user.displayName,
        "Points": 0,
        "isAdmin": true,
      });
      Navigator.of(buildContext).pop();
    }
  }
}

class AllFieldsForm extends StatefulWidget {
  @override
  _AllFieldsFormState createState() => _AllFieldsFormState();
}

class _AllFieldsFormState extends State<AllFieldsForm> {
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
                      icon: Icon(Icons.check),
                      label: Text(
                        'Create Group',
                        style: TextStyle(fontFamily: 'Nunito'),
                      ),
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
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: tertiaryColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: 'Nunito', color: tertiaryColor),
                                errorStyle: TextStyle(fontFamily: 'Nunito'),
                              ),
                              style: TextStyle(
                                  fontFamily: 'Nunito', color: Colors.white),
                              cursorColor: Colors.white,
                            ),
                            RadioButtonGroupFieldBlocBuilder<String>(
                              selectFieldBloc: formBloc.groupVisibility,
                              canDeselect: false,
                              decoration: InputDecoration(
                                labelText: 'Group Visibility',
                                prefixIcon: SizedBox(),
                                labelStyle: TextStyle(fontFamily: 'Nunito'),
                                errorStyle: TextStyle(fontFamily: 'Nunito'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0),
                                ),
                              ),
                              itemBuilder: (context, item) => item,
                            ),
                            RadioButtonGroupFieldBlocBuilder<String>(
                              selectFieldBloc: formBloc.groupType,
                              canDeselect: false,
                              decoration: InputDecoration(
                                labelText: 'Group Type',
                                prefixIcon: SizedBox(),
                                labelStyle: TextStyle(fontFamily: 'Nunito'),
                                errorStyle: TextStyle(fontFamily: 'Nunito'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 1.0),
                                ),
                              ),
                              itemBuilder: (context, item) => item,
                            ),
                            SizedBox(height: 10),
                            Text("Select a group icon:",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 15,
                                    color: tertiaryColor)),
                            SizedBox(height: 10),
                            HorizontalCardPager(
                              initialPage: 0, // default value is 2
                              onPageChanged: (page) {
                                selectedImageIndex = page.round();
                              },
                              onSelectedItem: (page) =>
                                  print("selected : $page"),
                              items: groupImageChoices,
                            )
                          ],
                        ),
                      )),
                )),
          );
        },
      ),
    );
  }
}
