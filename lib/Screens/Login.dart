import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/Navigation.dart';
import 'package:commutify/Screens/Register.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);

    onWillPop() {
      // Navigator.of(context).pop();
      SystemNavigator.pop();
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Welcome',
                  style: txt.lailared,
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      scale: 1.0,
                      image: AssetImage('assets/images/loginbck.png'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: color.themeA, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  style: TextStyle(),
                  controller: _emailController,
                  decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Color(0xffFF4F86)),
                      hintText: 'Enter Your Email Id',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: color.themeA, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  style: TextStyle(),
                  controller: _passController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security_rounded,
                          color: Color(0xffFF4F86)),
                      hintText: 'Enter Your Password ...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: InputBorder.none),
                ),
              ),
              Container(
                height: 45,
                decoration: deco.radius,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: MaterialButton(
                  color: color.themeA,
                  onPressed: () {
                    if (_emailController.text != null &&
                        _passController.text != null) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passController.text)
                          .then((value) async {
                        User user = value.user;
                        provider.setemail(_emailController.text);
                        provider.setpassword(_passController.text);
                        provider.setuid(user.uid);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Navigation()));
                      }).catchError((e) {
                        DialogBox(context, e.toString());
                      });
                    } else {
                      DialogBox2(context);
                    }
                  },
                  child: Text(
                    'Login',
                    style: txt.lailawhite,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: color.themeA,
                  thickness: 2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Center(
                  child: Container(
                    child: Text(
                      'Don\'t Have an Account? Register',
                      style: txt.andikasmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  void DialogBox(context, String error) {
    var baseDialog = AlertDialog(
      title: new Text("Login Failed"),
      content: Container(
        child:
            Text('Please try Again After Sometime or Enter Valid Credentials'),
        // Text(error),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.themeA,
          child: new Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  void DialogLoading(context) {
    var baseDialog = AlertDialog(
      title: new Text("Login Failed"),
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                backgroundColor: color.themeA,
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.themeA,
          child: new Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  void DialogBox2(context) {
    var baseDialog = AlertDialog(
      title: new Text("Warning"),
      content: Container(
        child: Text('Enter All The Fields'),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.themeA,
          child: new Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
