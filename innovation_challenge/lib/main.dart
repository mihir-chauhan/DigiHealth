import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
              navLargeTitleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            color: const Color(0x242424),
          )),
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new CupertinoPageScaffold(
        backgroundColor: const Color(0xFF121212),
        child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: const Color(0xFF121212),
            largeTitle:
                Text("DigiHealth", style: TextStyle(color: Colors.white)),
            leading: GestureDetector(
              onTap: () {

              },
              child: Icon(
                Icons.account_circle,
                color: CupertinoColors.white
              ),
            ),
          )
        ]));
  }
}
