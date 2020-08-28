import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'common/show_dialog.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("images/hourglass.png"),
                height: 90,
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'COMING \nSOON...',
                style: TextStyle(
                  fontFamily: ('Caviar Dreams'),
                  fontSize: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          color: Colors.blue,
          onPressed: () {
            _logOut();
          },
        ),
      ],
    );
  }

  void _logOut() async {
    await _auth.signOut().then((value) {
      Navigator.pushReplacementNamed(context, '/');
    }).catchError((e) {
      myDialog(context, 'Error', 'Wrong way...', 'Ok');
    });
  }
}
