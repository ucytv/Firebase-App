import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void myDialog(
    BuildContext mContext, String title, String content, String buttonText) {
  showDialog(
      context: mContext,
      //barrierColor: Colors.blue,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text(
                  buttonText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}
