import 'package:firebase_app/common/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  TextEditingController mailControl = TextEditingController();
  final requestKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool otoControl = false;

  final mailValidator = MultiValidator([
    RequiredValidator(errorText: 'E-Mail is required'),
    MinLengthValidator(3, errorText: 'E-Mail must be at least 6 digits long'),
    PatternValidator(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'E-Mail is invalid!'),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: buildAppbar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(60),
        child: Form(
          key: requestKey,
          autovalidate: otoControl,
          child: ListView(
            children: <Widget>[
              Image(
                image: AssetImage("images/fast.png"),
                height: 120,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Password \nReset',
                style: TextStyle(
                  fontFamily: 'Caviar Dreams',
                  fontSize: 48,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12.0, top: 36),
                child: TextFormField(
                  controller: mailControl,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'E-Mail Address',
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: mailValidator,
                  //onSaved: (value) => myName = value,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0),
                height: 50,
                child: RaisedButton(
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: ('Caviar Dreams'),
                    ),
                  ),
                  color: Colors.blue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _requestPass();
                  },
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

      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
    );
  }

  void _requestPass() async {
    if (requestKey.currentState.validate()) {
      await _auth.sendPasswordResetEmail(email: mailControl.text).then((v) {
        requestKey.currentState.save();
        Navigator.pushNamed(context, 'login/requestPassword/login');
      }).catchError((e) {
        myDialog(context, 'Error', 'Wrong way...', 'Ok');
      });
    } else {
      setState(() {
        otoControl = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    mailControl.dispose();
  }
}
