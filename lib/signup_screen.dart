import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'common/show_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signupKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameControl = TextEditingController();
  TextEditingController mailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController passCheckControl = TextEditingController();

  String myName, myMail, myPass, myPassCheck;
  bool otoControl = false;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(3, errorText: 'Password must be at least 6 digits long'),
  ]);

  final mailValidator = MultiValidator([
    RequiredValidator(errorText: 'E-Mail is required'),
    MinLengthValidator(3, errorText: 'E-Mail must be at least 6 digits long'),
    PatternValidator(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'E-Mail is invalid!'),
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name and surname are required'),
    MinLengthValidator(5,
        errorText: 'Name and surname must be at least 5 digits long')
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: buildAppbar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(right: 60,left:60,top:40),
        child: Form(
          key: signupKey,
          autovalidate: otoControl,
          child: ListView(
            children: <Widget>[
              Text(
                'JOIN \nTO\nUS',
                style: TextStyle(
                  fontFamily: 'Caviar Dreams',
                  fontSize: 48,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12.0, top:36),
                child: TextFormField(
                  controller: nameControl,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Name & Surname',
                    labelText: 'Name & Surname',
                    border: OutlineInputBorder(),
                  ),
                  validator: nameValidator,
                  //onSaved: (value) => myName = value,
                ),
              ),

              TextFormField(
                controller: mailControl,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'E-Mail Address',
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
                validator: mailValidator,
                //onSaved: (value) => myMail = value,
              ),
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: TextFormField(
                  controller: passControl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: passwordValidator,
                  //onSaved: (value) => myPass = value,
                ),
              ),
              TextFormField(
                controller: passCheckControl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (String inputPass) =>
                    MatchValidator(errorText: 'Passwords did not matched!')
                        .validateMatch(passControl.text, passCheckControl.text),
                //onSaved: (value) => myPassCheck = value,
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0),
                height: 50,
                child: RaisedButton(
                  child: Text(
                    'SIGN UP',
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
                    _signUp('/homePage/login');
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

  void _signUp(String route) async {
    if (signupKey.currentState.validate()) {
      /* try {

        signupKey.currentState.save();
        Navigator.pushReplacementNamed(context, route);
      } on FirebaseAuthException catch (e) {
        if(e.code =='weak-password'){
          print('Weak!');
        }else if(e.code == 'email-already-in-use'){
          print('E-Posta zaten kullanımda!');
        }
      }*/
      await _auth
          .createUserWithEmailAndPassword(
        email: mailControl.text,
        password: passControl.text,
      )
          .then((v) {
        //debugPrint(userCredential.user.email);
        _addData();
        signupKey.currentState.save();
        Navigator.pushReplacementNamed(context, route);
      }).catchError((e) {
        debugPrint('Hata' + e.toString());
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
    nameControl.dispose();
    passControl.dispose();
    passCheckControl.dispose();
  }

  void _addData(){
    Map<String, dynamic> addValue = Map();
    addValue['name']= nameControl.text;
    addValue['mail']= mailControl.text;

    _firestore.collection('users').doc(nameControl.text).set(addValue);
  }
/*void test() {
    (context, AsyncSnapshot<Object> snapshot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scaffold.of(context)
          ..showSnackBar(
            SnackBar(
              content: Text('Failed!'),
            ),
            // SnackBar
          );
      });
      return Container();
      // Rest ...
    };
  }*/
}
