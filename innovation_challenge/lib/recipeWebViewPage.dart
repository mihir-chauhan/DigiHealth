import 'package:DigiHealth/appPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeWebViewPage extends StatefulWidget {
  final String url;

  const RecipeWebViewPage(this.url);

  @override
  _RecipeWebViewPageState createState() => _RecipeWebViewPageState();
}

class _RecipeWebViewPageState extends State<RecipeWebViewPage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "recipeWebViewPage",
            middle: Text("Recipe",
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              child: Icon(
                Icons.circle,
                color: secondaryColor,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.done,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }
}