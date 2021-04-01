import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Feature> features = [
    Feature(
      title: "Yoga",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Exercise",
      color: Colors.pink,
      data: [1, 0.8, 0.6, 0.7, 0.3],
    )
  ];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            middle: Text("Profile",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              onTap: () async {
                try {
                  AuthService auth = Provider
                      .of(context)
                      .auth;
                  await auth.signOut();
                  print("Signed Out!");
                } catch (e) {
                  print(e);
                }
              },
              child: Icon(
                Icons.exit_to_app_rounded,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      Text("My Stats",
                          style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      Container(
                        width: _width,
                        height: _height * 0.001,
                        color: secondaryColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LineGraph(
                              features: features,
                              size: Size(320, 300),
                              labelX: ['Day 1', 'Day 5', 'Day 10', 'Day 15', 'Day 20'],
                              labelY: ['20', '40', '60', '80', '100'],
                              showDescription: true,
                              graphColor: Colors.white60,
                            ),
                          )),
                      SizedBox(
                        height: _height * 0.1,
                      ),
                      Text("My Rank",
                          style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                      Container(
                        width: _width,
                        height: _height * 0.001,
                        color: secondaryColor,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset("rank.png"),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Ranking: 1st Place",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                    ],
                  ),
                )),
          ),
        ));
  }
}


