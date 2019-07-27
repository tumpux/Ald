import 'package:flutter/material.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';
import 'package:flutter_girlies_store/tools/app_methods.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/firebase_methods.dart';
import 'package:flutter_girlies_store/userScreens/signup.dart';

class GirliesLogin extends StatefulWidget {
  @override
  _GirliesLoginState createState() => _GirliesLoginState();
}

class _GirliesLoginState extends State<GirliesLogin> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  AppMethods appMethod = new FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Login"),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: false,
                sidePadding: 18.0,
                textHint: "Email Address",
                textIcon: Icons.email,
                controller: email),
            new SizedBox(
              height: 30.0,
            ),
            appTextField(
                isPassword: true,
                sidePadding: 18.0,
                textHint: "Password",
                textIcon: Icons.lock,
                controller: password),
            appButton(
                btnTxt: "Login",
                onBtnclicked: verifyLoggin,
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor),
            new GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new SignUp()));
              },
              child: new Text(
                "Not Registered? Sign Up Here",
                style: new TextStyle(color: Colors.white),
              ),
            ),


            new GestureDetector(
              onTap: () {
               /* Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new SignUp()));*/

               _resetpassword();


              },
              child: new Text(
                "\nForget Password",
                style: new TextStyle(color: Colors.white),
              ),
            )


          ],
        ),
      ),
    );
  }

  _resetpassword() async {


    if (email.text == "") {
      showSnackBar("Email cannot be empty", scaffoldKey);
      return;
    }

      String response = await appMethod.resetPassword(
        email: email.text.toLowerCase().trim(),);

      if (response == 'success') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Email has been sent"),
              //content: new Text("Alert Dialog body"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showSnackBar(response, scaffoldKey);
        return;
   /*     showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text(response),
              //content: new Text("Alert Dialog body"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );*/
      }

  }

  verifyLoggin() async {
    if (email.text == "") {
      showSnackBar("Email cannot be empty", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("Password cannot be empty", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    String response = await appMethod.logginUser(
        email: email.text.toLowerCase(), password: password.text.toLowerCase());
    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop(true);
    } else {
      closeProgressDialog(context);
      print ('response $response');
      showSnackBar(response, scaffoldKey);
    }
  }
}
