import 'package:firebase_app/common/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

/*'/': (context) => LoginScreen(),
'login': (context) => LoginScreen(),
'/homePage': (context) => HomePageScreen(),
'/requestPassword': (context) => RequestPassScreen(),*/

class _LoginScreenState extends State<LoginScreen> {
  String myMail, myPassword;
  bool otoControl = false;
  bool boxControl = false;

  TextEditingController mailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  final loginKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  final mailValidator = MultiValidator([
    RequiredValidator(errorText: 'E-Mail is required'),
    MinLengthValidator(10, errorText: 'E-Mail must be at least 10 digits long'),
    PatternValidator(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'E-Mail is invalid!'),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(),
      body: Padding(
        padding: EdgeInsets.only(left: 55, right: 55, top: 80),
        child: Form(
          key: loginKey,
          autovalidate: otoControl,
          child: ListView(
            children: <Widget>[
              Image(
                image: AssetImage("images/e_Consultant.png"),
                height: 80,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12, top:72),
                child: TextFormField(
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
              ),
              TextFormField(
                controller: passControl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),

                ),
                validator: passwordValidator,
                onSaved: (value) => myPassword = value,
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 24, bottom: 8),
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5,
                  onPressed: () {
                    _loginStep('login/homePage');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontFamily: ('Caviar Dreams'),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                //margin: EdgeInsets.only(bottom: 8),
                child: RaisedButton(
                  color: Colors.blueGrey,
                  elevation: 5,
                  onPressed: () {
                    Navigator.pushNamed(context, '/requestPassword');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Forgot my password',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontFamily: ('Caviar Dreams'),
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.white,
                    elevation: 0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: Text(
                      'Don t have an account yet?',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        fontFamily: ('Caviar Dreams'),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    elevation: 0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontFamily: ('Caviar Dreams'),
                      ),
                    ),
                  ),
                ],
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
    );
  }

  @override
  void initState() {
    super.initState();
    _checkUser();

    /*if (await _auth.currentUser != null) {
      Navigator.of(context).pushReplacementNamed('/homePage');
    }*/
  }

  Future<void> _checkUser() async {
    if (await _auth.currentUser != null) {
      setState(() {
        Navigator.pushReplacementNamed(context, 'login/homePage');
      });
      debugPrint(_auth.currentUser.email);
    }
  }

  @override
  void dispose() {
    super.dispose();
    mailControl.dispose();
    passControl.dispose();
  }

  void _loginStep(String route) async {
    if (loginKey.currentState.validate()) {
      //_auth.createUserWithEmailAndPassword(email: myMail, password: myPassword);
      var userCredential = await _auth
          .signInWithEmailAndPassword(
              email: mailControl.text, password: passControl.text)
          .then((v) {
        loginKey.currentState.save();
        Navigator.pushReplacementNamed(context, route);
      }).catchError((e) {
        debugPrint('Hata' + e.toString());

        myDialog(context, 'Error', 'Wrong way...', 'Ok');
      });
      if (userCredential != null) {
        debugPrint(userCredential.user.email);
      }
    } else {
      setState(() {
        otoControl = true;
      });
    }
  }
}
