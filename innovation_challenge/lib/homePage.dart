import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innovation_challenge/provider_widget.dart';
import 'package:innovation_challenge/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: primaryColor,
        child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                backgroundColor: primaryColor,

                leading: GestureDetector(
                  onTap: () async {
                    debugPrint('Menu Tapped');
                    try {
                      AuthService auth = Provider.of(context).auth;
                      await auth.signOut();
                      print("Signed Out!");
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: CupertinoColors.white,
                    size: 35,
                  ),
                ),
                largeTitle: Text("Home", style: TextStyle(color: Colors.white)),
                trailing: GestureDetector(
                  onTap: () {
                  },
                  child: Icon(
                    Icons.directions_run_rounded,
                    color: CupertinoColors.white,
                    size: 30,
                  ),
                ),
              )
            ]
        )
    );
  }
}
