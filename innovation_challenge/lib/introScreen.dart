import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        backgroundColor: Color(0xFF001d36),
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
            "Automatically load fitness data from Apple Health or Google Fit! Earn points through exercising and win medals by completing challenges!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.sports_handball_rounded,
          size: 200.0,
          color: Color(0xFFccada9),
        ),
        backgroundColor: Color(0xFF765C59),
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
          color: Color(0xFFdb937d),
        ),
        backgroundColor: Color(0xFFab492c),
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
            "You can view your everyday adventures in DigiFit and body metrics in DigiDiet!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.trending_up_rounded,
          size: 200.0,
          color: Color(0xFFf5e578),
        ),
        backgroundColor: Color(0xFFab9b2c),
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
          color: Color(0xFFc6edb2),
        ),
        backgroundColor: Color(0xFF76ae59),
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
            "Compete through points to become the DigiHealth champion!",
        styleDescription: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.white,
          fontSize: 25.0,
        ),
        centerWidget: Icon(
          Icons.leaderboard_rounded,
          size: 200.0,
          color: Color(0xFFb37f90),
        ),
        backgroundColor: Color(0xFF6b3345),
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
      onSkipPress: () {
        this.onDonePress();
      },
      colorActiveDot: Colors.white,
      colorDot: Colors.white30,
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
