import 'package:DigiHealth/appPrefs.dart';
import 'package:DigiHealth/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "DigiHealth",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 50.0,
          fontWeight: FontWeight.w700,
        ),
        description: "Welcome to DigiHealth: Health Like Never Before!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 30.0,
        ),
        pathImage: "assets/DigiHealthLogoAndroid.png",
        backgroundColor: primaryColor,
      ),
    );
    slides.add(
      new Slide(
        title: "DigiFit",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        description:
            "No need to open the app to record activity! Earn points through exercising and win medals for bonus points to your showcase!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.sports_handball_rounded,
          size: 200.0,
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.orangeAccent,
      ),
    );
    slides.add(
      new Slide(
        title: "DigiDiet",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        description:
            "Planning meals has never been easier with custom recommendations based on your diet!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.fastfood_rounded,
          size: 200.0,
          color: Colors.pink[200],
        ),
        backgroundColor: Colors.purpleAccent,
      ),
    );
    slides.add(
      new Slide(
        title: "Personal Stats",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        description:
            "You can view both your everyday adventures in DigiFit and body metrics in DigiDiet!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.trending_up_rounded,
          size: 200.0,
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.red,
      ),
    );
    slides.add(
      new Slide(
        title: "Community Chats",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        description:
            "Talk with the DigiHealth community for encouragement and friendly competition!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.chat_rounded,
          size: 200.0,
          color: Colors.teal,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
    );
    slides.add(
      new Slide(
        title: "Leaderboard",
        styleTitle: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.w600,
        ),
        description:
            "Compete through points to become the DigiHealth champ and aim for the one-and-only DigiHealth medal!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.leaderboard_rounded,
          size: 200.0,
          color: Colors.brown,
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Navigator.pushNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
